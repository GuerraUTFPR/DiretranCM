class Endereco < ApplicationRecord
  belongs_to :pessoa

  validates :cep,
  presence:  {message: ": deve ser preenchido"},
  length: {maximum: 9, message: ": maximo de 8 digitos"},
  numericality: {message: "Somente numeros"}

  validates :cidade,
  presence: {message: ": deve ser preenchido"},
  length: {maximum: 50, message: ": maximo de 50 digitos"}

  validates :bairro,
  presence: {message: ": deve ser preenchido"},
  length: {maximum: 50, message: ": maximo de 50 digitos"}

  validates :logradouro,
  presence: {message: ": deve ser preenchido"},
  length: {maximum: 130, message: ": maximo de 130 digitos"}

  validates :numero,
  presence: {message: ": deve ser preenchido"},
  length: {maximum: 6, message: ": maximo de 6 digitos"}
  #numericality: {only_integer: true, message: ": deve ser preenchido com números"}

  validates :complemento,
  #presence: {message: ": deve ser preenchido"},
  length: {maximum: 255, message: ": maximo de 255 digitos"}

end
