defmodule Idris.Mix.Build do
  @moduledoc false

  alias Idris.Mix.Idris

  def compile(args) do
    config = Mix.Project.config()
    codegen = List.keyfind(config, :idris_codegen, 0)
    main = List.keyfind(config, :idris_main, 0) || List.keyfind(config, :idris_ipkg, 0)
    compile(main, codegen, args, config)
  end

  defp compile({:idris_main, main_file}, {:idris_codegen, codegen}, args, config) do
    compile_main_file(main_file, codegen, args, config)
  end

  defp compile_main_file(main_file, codegen, args, config) do
    {cg_name, cg_opts} = codegen

    cg = String.to_existing_atom("idris_codegen_#{cg_name}")
    {idris, cg_opts} = Idris.executable_from_opts(cg_opts)

    args = Enum.concat([cg_opts, deps_paths(config), args, [main_file]])
    args = args |> Idris.opts_to_argv() |> cg.opts

    Idris.print_verbose_info(idris, args, {"idr", [main_file]}, true)

    env = Idris.env_prepend_path(cg.bin_path)
    Idris.run_with_callback(idris, &cg.run/1, args: args, env: env, cd: File.cwd!())
  end

  defp deps_paths(config) do
    config[:deps]
    |> Enum.flat_map(&dep_path(&1, config))
  end

  defp dep_path(dep, config) do
    deps_path = config[:deps_path]
    [name | rest] = dep |> Tuple.to_list()

    case Enum.reverse(rest) do
      [opts | _] when is_list(opts) ->
        cond do
          opts[:idris] == :source && opts[:path] ->
            path = Path.expand(opts[:path])
            [idrispath: path]

          opts[:idris] == :source ->
            path = Path.expand(to_string(name), deps_path)
            [idrispath: path]

          :else ->
            []
        end

      _ ->
        []
    end
  end
end
