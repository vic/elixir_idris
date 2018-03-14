defmodule Idris.Mix.Idris do
  @moduledoc "Functions for running idris executable" && false

  @idris_exec "idris"
  @idris_callback "idris-callback"

  def run_with_callback(exec, callback, options) do
    tasks = cmd(exec, {_acc = [], callback_task(callback)}, options)
    raise_when_never_called_back!(tasks)
    results = Task.yield_many(tasks)
    Enum.all?(results, fn {_, {:ok, _}} -> true end)
    :ok
  end

  defp callback_task(callback) do
    fn @idris_callback <> " " <> args ->
      Task.async(fn ->
        args |> OptionParser.split() |> callback.()
      end)
    end
  end

  def executable_from_opts(opts) do
    idris =
      (List.keytake(opts, :idris, 0) || List.keytake(opts, "--idris", 0) ||
         {:default, @idris_exec})
      |> elem(1)
      |> System.find_executable()

    opts = opts |> List.keydelete(:idris, 0) |> List.keydelete("--idris", 0)
    raise_on_nil_exec!(idris)
    {idris, opts}
  end

  def env_prepend_path(prepend_path) do
    System.get_env()
    |> (fn env ->
          path = env["PATH"]
          %{env | "PATH" => "#{prepend_path}:#{path}"}
        end).()
    |> Enum.map(fn {k, v} -> {to_charlist(k), to_charlist(v)} end)
  end

  def print_verbose_info(exec, args, {ext, files}, verbose?) do
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

  def opts_to_argv(opts) do
    Enum.map(opts, fn
      {k, v} when is_atom(k) and (v === true or v == nil) ->
        ["--#{k}"]

      {k, v} when is_atom(k) and is_binary(v) ->
        ["--#{k}", v]

      {k, v} when is_binary(v) ->
        [k, v]

      {k, x} when x == true or x == nil ->
        [k]

      v when is_binary(v) ->
        v
    end)
    |> List.flatten()
  end

  defp cmd(exec, meta, opts) do
    settings =
      [
        :stderr_to_stdout,
        :binary,
        :exit_status,
        line: 1024 * 1024
      ] ++ opts

    port = Port.open({:spawn_executable, exec}, settings)
    stream_output(port, meta)
  end

  defp idris_take_exec(nil), do: @idris_exec
  defp idris_take_exec({{_, idris}, _}), do: idris

  defp raise_on_nil_exec!(nil) do
    Mix.raise("""
    No `idris` executable found on PATH.

    Please specify one with the `--idris executable` option
    or update your PATH.

    See `mix help compile.idris_json`
    """)
  end

  defp raise_on_nil_exec!(_), do: nil

  defp stream_output(port, meta = {pids, callback}) do
    receive do
      {^port, {:data, {:eol, data = @idris_callback <> _}}} ->
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
        raise_idris_failed(status)
    end
  end

  defp raise_idris_failed(status) do
    Mix.raise("""
    Idris failed with exit status #{status}
    """)
  end

  defp raise_when_never_called_back!([]) do
    Mix.raise("""
    Idris code compiled but never called back.

    Did you forget `--interface` option when your
    Idris program does not have a `Main.main`?
    """)
  end

  defp raise_when_never_called_back!(_), do: nil
end
