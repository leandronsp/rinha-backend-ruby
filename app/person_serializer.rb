class PersonSerializer
  def initialize(person)
    @person = person
  end

  def serialize
    return {} unless @person

    {
      id: @person['id'],
      apelido: @person['nickname'],
      nome: @person['name'],
      nascimento: @person['birth_date'],
      stack: (@person['stack'] || '').split(' ')
    }
  end
end
