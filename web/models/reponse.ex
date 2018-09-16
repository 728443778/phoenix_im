defmodule PhoenixIm.Response do
  def response(code, data \\ %{}, msg \\ "") do
    %{code: code, data: data, msg: msg}
  end

  def codeInvalidParam do
    400
  end

  def codeIsOk do
    0
  end

  def codeNotFound do
    404
  end

end