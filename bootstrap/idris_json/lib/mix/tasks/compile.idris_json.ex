defmodule Mix.Tasks.Compile.IdrisJson do
  use Mix.Task

  @shortdoc "Compile Idris -> JSON IR -> BEAM/Elixir"

  @output_option_info ~s"""
  Valid values are:

  "elixir" - will print elixir code to stdout

  "elixir:PATH" - will write a file per module in PATH

  "beam:PATH" - will compile into beam bytecode in PATH
  """

  @moduledoc ~s"""
  #{@shortdoc}

  Usage: mix compile.idris_json [IDRIS_OPTIONS]

  ## IDRIS_OPTIONS

     Those documented in `idris --help`

  ## SPECIAL OPTIONS

  `--idris EXECUTABLE` - Specify the idris compiler to use

  `--only MODULES` - Comma separated Idris module names to produce codegen

  `--skip MODULES` - Comma separated Idris module names to ignore from codegen

  `--output OUTPUT` - Specify where to place output

    #{@output_option_info}


  ## CONFIG

  You can also configure this compiler in your `mix.exs`

  ```elixir
     def project() do
       [
        compilers: [:idris_json] ++ Mix.compilers,
       ]
     end
  ````

  An `APP.ipkg` file must be present on your project.

  See the `hello_idris` example app.

  """

  @idris_exec "idris"
  @idris_opts [
    {"--codegenonly", nil},
    {"--portable-codegen", "json"}
  ]
  @codegen_path Path.expand("../../../bin/", __DIR__)
  @codegen_name "idris-codegen-json"

  @ipkg_opts ~W[ --build --install --repl
            --clean --mkdoc --installdoc
            --checkpkg --testpkg ]


  @spec run(OptionParser.argv()) :: :ok | :no_return
  def run(args) do
    config = Mix.Project.config()
    args = default_args(args, config)
    {files, opts} = OptionParser.parse(args) |> files_and_opts
    :ok = build(files, opts)
  end

  defp codegen_run(@codegen_name <> " " <> args) do
    Task.async(fn ->
      argv = OptionParser.split(args)
      IdrisBootstrap.Json.main(argv)
    end)
  end

  defp build(files, opts) do
    {idris, opts} = idris_executable(opts)

    {argv, files} =
      case ipkg_option(opts) do
        {_, ipkg} ->
          argv = opts_to_argv(opts)
          files = ipkg |> List.wrap()
          {argv, {"ipkg", files}}

        nil ->
          raise_on_empty_files(files)
          opts = @idris_opts ++ ensure_valid_output(opts)
          argv = opts_to_argv(opts) ++ files
          {argv, {"idr", files}}
      end

    idris_run(idris, argv, files)
  end

  defp ipkg_option(opts) do
    @ipkg_opts |> Enum.find_value(&List.keyfind(opts, &1, 0))
  end

  defp idris_run(idris, argv, files) do
    print_verbose_info(idris, argv, files, true)

    tasks = cmd(idris, argv, cwd(), env(), {_tasks = [], &codegen_run/1})
    raise_when_never_called_back(tasks)

    # TODO
    results = Task.yield_many(tasks)
    Enum.all?(results, fn {_, {:ok, _}} -> true end)
    :ok
  end

  defp default_args(args, config) do
    ipkg_file = get_in(config, [:idris_json, :ipkg_file]) || "#{config[:app]}.ipkg"
    if File.exists?(ipkg_file) do
      ipkg_build_args(ipkg_file, ipkg_build_opts(args, config))
    else
      []
    end
  end

  defp ipkg_build_opts(args, config) do
    args = (Enum.empty?(args) && get_in(config, [:idris_json, :ipkg_opts])) || args
    {_files, opts} = OptionParser.parse(args) |> files_and_opts
    opts = @idris_opts ++ ensure_valid_output(opts)
    opts_to_argv(opts)
    |> IO.inspect
  end

  defp ipkg_build_args(ipkg_file, build_opts) do
    basename = Path.basename(ipkg_file)
    build_dir = Path.expand("_build/#{Mix.env()}/lib-idris")
    build_opts = build_opts |> Enum.join(" ")

    File.mkdir_p!(build_dir)
    ipkg_tmp = Path.expand(basename, build_dir)

    content = File.read!(ipkg_file) <> """
    opts = "#{build_opts}"
    """

    File.write!(ipkg_tmp, content)
    [
      "--ibcsubdir",
      build_dir,
      "--build",
      ipkg_tmp
    ]
  end

  defp files_and_opts({parsed, files, opts}) do
    opts =
      (opts ++
         Enum.map(parsed, fn
           {:only, v} ->
             String.split(v, ",") |> Enum.map(&[{"--cg-opt", "--only=#{&1}"}])

           {:skip, v} ->
             String.split(v, ",") |> Enum.map(&[{"--cg-opt", "--skip=#{&1}"}])

           {k, v} ->
             {"--#{k}", v}
         end))
      |> List.flatten()

    {files, opts}
  end

  defp opts_to_argv(opts) do
    Enum.map(opts, fn
      {k, v} when is_binary(v) -> [k, v]
      {k, x} when x == true or x == nil -> [k]
    end)
    |> List.flatten()
  end

  defp cmd(exec, args, cwd, env, meta) do
    settings = [
      :stderr_to_stdout,
      :binary,
      :exit_status,
      line: 1024 * 1024,
      args: args,
      cd: cwd,
      env: env
    ]

    port = Port.open({:spawn_executable, exec}, settings)
    stream_output(port, meta)
  end

  defp stream_output(port, meta = {pids, callback}) do
    receive do
      {^port, {:data, {:eol, data = @codegen_name <> _}}} ->
        pid = callback.(data)
        stream_output(port, {[pid] ++ pids, callback})

      {^port, {:data, {:noeol, data}}} ->
        IO.write(data)
        stream_output(port, meta)

      {^port, {:data, {:eol, data}}} ->
        IO.puts(data)
        stream_output(port, meta)

      {^port, {:exit_status, 0}} ->
        pids

      {^port, {:exit_status, status}} ->
        raise_idris_compiler_failed(status)
    end
  end

  defp raise_idris_compiler_failed(status) do
    Mix.raise("""
    Idris compiler failed with status #{status}
    """)
  end

  defp print_verbose_info(exec, args, {ext, files}, verbose?) do
    args =
      Enum.map_join(args, " ", fn arg ->
        if String.contains?(arg, " "), do: inspect(arg), else: arg
      end)

    files =
      case files do
        [_] -> "1 file"
        _ -> "#{length(files)} files"
      end

    info = (verbose? && " with: #{exec} #{args}") || ""

    Mix.shell().info("Building #{files} (.#{ext})#{info}")
  end

  defp cwd do
    File.cwd!()
  end

  defp env do
    System.get_env()
    |> (fn env ->
          path = env["PATH"]
          %{env | "PATH" => "#{@codegen_path}:#{path}"}
        end).()
    |> Enum.map(fn {k, v} -> {to_charlist(k), to_charlist(v)} end)
  end

  defp idris_executable(opts) do
    idris =
      opts
      |> List.keytake("--idris", 0)
      |> idris_take_exec
      |> System.find_executable()

    opts = List.keydelete(opts, "--idris", 0)
    raise_on_nil_exec(idris)
    {idris, opts}
  end

  defp idris_take_exec(nil), do: @idris_exec
  defp idris_take_exec({{_, idris}, _}), do: idris

  defp raise_on_nil_exec(nil) do
    Mix.raise("""
    No `idris` executable found on PATH.

    Please specify one with the `--idris executable` option
    or update your PATH.

    See `mix help compile.idris_json`
    """)
  end

  defp raise_on_nil_exec(_), do: nil

  defp raise_on_empty_files([]) do
    Mix.raise("""
    You must specify at least one `.idr` source
    file to compile.

    See `mix help compile.idris_json`
    """)
  end

  defp raise_on_empty_files(_), do: nil

  defp ensure_valid_output(opts) do
    output = Enum.find_value(opts, &output_opt/1)

    case output do
      nil ->
        [{"--output", "elixir"}] ++ opts

      _ ->
        raise_on_invalid_output(output)
        opts
    end
  end

  defp output_opt({"-o", output}), do: output
  defp output_opt({"--output", output}), do: output
  defp output_opt(_), do: nil

  defp raise_on_invalid_output("beam:" <> _), do: nil
  defp raise_on_invalid_output("elixir:" <> _), do: nil

  defp raise_on_invalid_output(output) do
    Mix.raise("""
    Invalid output type #{output}

    #{@output_option_info}
    """)
  end

  defp raise_when_never_called_back([]) do
    Mix.raise("""
    Idris code compiled but never called back.

    Did you forget `--interface` option when your
    Idris program does not have a `Main.main`?
    """)
  end

  defp raise_when_never_called_back(_), do: nil
end
