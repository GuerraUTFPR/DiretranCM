class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  # !LER redirecionar, mudar ainda
  def after_sign_in_path_for(resource)
    if(authAdmin() == true)
     dash_dashFuncionario_path
    elsif(authFuncionario() == true)
     dash_dashFuncionario_path
    elsif(getPessoa() != nil)
     dash_dashUsuario_path
    else
     new_pessoa_path
    end
  end
  def after_sign_out_path_for(resource)
    root_path
  end

  helper_method :populate_info_carteirinha
  def populate_info_carteirinha
    filePath = File.join(Rails.root, 'app', 'json', 'dados.json')
    file = File.read(filePath)
    dadosDoArquivo = JSON.parse(file)
    ic = Info_carteirinha.new(:nome_tipo_estacionamento => dadosDoArquivo[0]['nome_tipo_estacionamento'],:resolucao => dadosDoArquivo[0]['resolucao'],:uf => dadosDoArquivo[0]['uf'],municipio => dadosDoArquivo[0]['municipio'],:orgao_expedidor => dadosDoArquivo[0]['orgao_expedidor'],:nome_diretor => dadosDoArquivo[0]['nome_diretor'],:orgao_exp_diretor => dadosDoArquivo[0]['orgao_exp_diretor'],:regras_utilizacao => dadosDoArquivo[0]['regras_utilizacao'],:numeracao_carteirinha => dadosDoArquivo[0]['numeracao_carteirinha'])
    ic.save
  end


# Recebe objeto Pessoa do usuario atual
  helper_method :getPessoa
  def getPessoa()
    pessoas = Pessoa.all
    pessoas.each do |pessoa|
      if pessoa.usuario_id == current_usuario.id
        return pessoa
      end
    end
    return nil
  end

# Recebe objeto Pessoa do usuario atual
  helper_method :getPessoaById
  def getPessoaById()
    pessoas = Pessoa.all
    pessoas.each do |pessoa|
      if pessoa.usuario_id == current_usuario.id
        return pessoa
      end
    end
    return nil
  end

# Recebe id do Usuario de acordo com o id do currentusuario
  helper_method :getUserId
  def getUserId(idDeviseUser)
    pessoas = Pessoa.all
    pessoas.each do |usuario|
      if usuario.usuario_id == idDeviseUser
        return usuario.id
      end
    end
    return nil
  end

# Se admin retorna TRUE
  helper_method :authAdmin
  def authAdmin()
    if current_usuario.try(:admin?)
      true
    else
      false
    end
  end

# Se funcionário retorna TRUE
  helper_method :authFuncionario
  def authFuncionario()
    if current_usuario.try(:funcionario?)
      true
    else
      false
    end
  end

  #Se funcionario ou admin
  helper_method :authFuncOrAdmin
  def authFuncOrAdmin()
    if current_usuario.try(:admin?) || current_usuario.try(:funcionario?)
      true
    else
      false
    end
  end

# Se funcionário retorna TRUE
  helper_method :authFunc
  def authFunc()
    if current_usuario.try(:funcionario?)
      true
    else
      false
    end 
  end



# Usado no menu: se não exister Pessoa redireciona para criar
  helper_method :verifyUser
  def verifyUser()
    usuarioId = getUserId(current_usuario.id)
    if usuarioId == 0
      return new_pessoa_path
    end
    else
       return edit_pessoa_path(usuarioId)
  end


# Usado no menu: redireciona de acordo com o tipo de usuario
  helper_method :isLogged
  def isLogged()
    if current_usuario.try(:admin?)
      return dash_dashFuncionario_path
    elsif current_usuario.try(:funcionario?)
      return dash_dashFuncionario_path
    elsif usuario_signed_in?
      return dash_dashUsuario_path
    else
      return usuario_session_path
    end
  end

# Usado no menu: utiliza o redirect em conjunto com a def anterior
  helper_method :redirectTypeOfUser
  def redirectTypeOfUser()
    redirect_to isLogged()
  end

# Retorna id da Requisicao de acordo com o usuario atual
  helper_method :returnReqq
  def returnReqq()
    req = Requisicao.all
    pes = Pessoa.all
    pesId = nil
    retorno = nil
    pes.each do |pes|
      if pes.usuario_id == current_usuario.id
        pesId = pes.id
      end
    end
    if pesId == nil
      return nil
    end
    req.each do |req|
      if req.pessoa_id == pesId
        return req.id
      end
    end
    return nil
  end


# Retorna endereço da Requisicao de acordo com o usuario atual
  helper_method :returnReqEnd
  def returnReqEnd()
    iter = returnReqq()
    if iter != nil
      return edit_requisicao_path(iter)
    else
      return new_requisicao_path
    end
  end

  #Pessoa init
# Retorna id da Pessoa atual
  helper_method :returnPes
  def returnPes()
    pessoa = Pessoa.all
    retorno = nil
    pessoa.each do |itera|
      if itera.usuario_id == current_usuario.id
         return itera.id
      else
        retorno = nil
      end
    end
    return retorno
  end


# Redireciona para novo ou editar do usuario atual
  helper_method :returnPesEnd
  def returnPesEnd()
    iter = returnPes()
    if iter != nil
      return edit_pessoa_path(iter)
    else
      return new_pessoa_path
    end
  end
  #Pessoa end


  #Documento init
# Retorna id do Documento atual
  helper_method :returnDoc
  def returnDoc()
    documentos = Documento.all
    pessoaId = returnPes()
    if pessoaId != nil
      pessoa = Pessoa.find(pessoaId)
      #return @pessoa.id
      retorno = nil
      documentos.each do |itera|
        if itera.pessoa_id == pessoa.id
           return itera.id
        else
          retorno = nil
        end
      end
      return retorno
    end
  end


# Redireciona para novo ou editar do usuario atual
  helper_method :returnDocEnd
  def returnDocEnd()
    iter = returnDoc()
    if iter != nil
      return edit_documento_path(iter)
    else
      return new_documento_path
    end
  end
  #Documento end


  #Endereço init
# Retorna id do Endereço atual
  helper_method :returnEnd
  def returnEnd()
    endereco = Endereco.all
    pessoaId = returnPes()
    if pessoaId != nil

      pessoa = Pessoa.find(pessoaId)
      #return @pessoa.id
      retorno = nil
      endereco.each do |itera|
        if itera.pessoa_id == pessoa.id
           return itera.id
        else
          retorno = nil
        end
      end
      return retorno
    end
  end


# Redireciona para novo ou editar do usuario atual
  helper_method :returnEndEnd
  def returnEndEnd()
    iter = returnEnd()
    if iter != nil
      return edit_endereco_path(iter)
    else
      return new_endereco_path
    end
  end

  helper_method :returnEndIf
  def returnEndIf()
    iter = returnEnd()
    if iter != nil
      return root_path
    else
      return new_endereco_path
    end

  end
  #Endereço end



  #Requisição init
# Retorna id da Requisição atual
  helper_method :returnReq
  def returnReq()
    requisicao = Requisicao.all
    pessoaId = returnPes()
    if pessoaId != nil
      pessoa = Pessoa.find(pessoaId)
      #return @pessoa.id
      retorno = nil
      requisicao.each do |itera|
        if itera.pessoa_id == pessoa.id
           return itera.id
        else
          retorno = nil
        end
      end
      return retorno
    end
  end


# Redireciona para novo ou editar do usuario atual
  helper_method :returnReqEnd
  def returnReqEnd()
    iter = returnReq()
    if iter != nil
      return edit_requisicao_path(iter)
    else
      return new_requisicao_path
    end
  end
  #Requisição end


  #Carteirinha init
# Retorna id da 'Carteirinha atual'
  helper_method :returnCar
  def returnCar()
    carteirinhas = Carteirinha.all
    retorno = nil

    reqId = returnReqq()
    if reqId != nil
      req = Requisicao.find(reqId)
      #return @pessoa.id
      carteirinhas.each do |itera|
        if itera.requisicao_id == req.id
           return itera.id
        else
          retorno = nil
        end
      end
    end
    return retorno
  end


# Redireciona para novo ou editar do usuario atual
  helper_method :returnCarEnd
  def returnCarEnd()
    iter = returnCar()
    if iter != nil
      return edit_carteirinha_path(iter)
    else
      return new_carteirinha_path
    end
  end
  #Carteirinha end

  #Cid init
# Retorna id da Cid atual
  helper_method :returnCid
  def returnCid()
    cid = Cid.all

    reqId = returnReqq()
    if reqId != nil
      req = Requisicao.find(reqId)
      #return @pessoa.id
      retorno = nil
      cid.each do |itera|
        if itera.requisicao_id == req.id
           return itera.id
        else
          retorno = nil
        end
      end
      return retorno
    end
  end


# Redireciona para novo ou editar do usuario atual
  helper_method :returnCidEnd
  def returnCidEnd()
    iter = returnCar()
    if iter != nil
      return edit_cid_path(iter)
    else
      return new_cid_path
    end
  end
  #Cid end

  #Status da Carteirinha
  helper_method :resCart
  def resCart()

    #id carteirinha 
    idCarteirinha = returnCar()
    retorno = nil
    if idCar=!nil
      #@carteirinha = Carteirinha.find(@idCar)
      carteirinhas = Carteirinha.all
      carteirinhas.each do |c|
        if c.id == idCarteirinha
          retorno = c.status
        end
      end
      return retorno
    else
      return nil
    end

     
  end

  #Motivo da rejeição
  helper_method :rejMot
  def rejMot()

    #id carteirinha 
    idCar = returnCar()
    carteirinha = Carteirinha.find(idCar)
    return carteirinha.motivo

     
  end

#Carteirinhas Aprovadas
#Carteirinhas Aguardando
#Carteirinhas Reprovadas
#Carteirinhas Vencidas
  helper_method :aguardCarteirinhas
  def aguardCarteirinhas()
    carteirinhas = Carteirinha.all
    totalCarteirinhas = 0
    carteirinhas.each do |carteirinha|
      if carteirinha.status == "Em Analise"
        totalCarteirinhas = totalCarteirinhas + 1
      end
    end
    return totalCarteirinhas
  end

  helper_method :aprovCarteirinhas
  def aprovCarteirinhas()
    carteirinhas = Carteirinha.all
    totalCarteirinhas = 0
    carteirinhas.each do |carteirinha|
      if carteirinha.status == "Aprovada"
        totalCarteirinhas = totalCarteirinhas + 1
      end
    end
    return totalCarteirinhas
  end

  helper_method :reprovCarteirinhas
  def reprovCarteirinhas()
    carteirinhas = Carteirinha.all
    totalCarteirinhas = 0
    carteirinhas.each do |carteirinha|
      if carteirinha.status == "Rejeitada"
        totalCarteirinhas = totalCarteirinhas + 1
      end
    end
    return totalCarteirinhas
  end

  helper_method :vencidasCarteirinhas
  def vencidasCarteirinhas()
    carteirinhas = Carteirinha.all
    totalCarteirinhas = 0
    carteirinhas.each do |carteirinha|
      if carteirinha.status == "Vencida"
        totalCarteirinhas = totalCarteirinhas + 1
      end
    end
    return totalCarteirinhas
  end

# Retorna o nome do usuario atual
  helper_method :returnPessoaOnUsuario
  def returnPessoaOnUsuario(idUsuario)
    pessoas = Pessoa.all
    pessoas.each do |pessoaa|
      if pessoaa.usuario_id == idUsuario
        return pessoaa.nome
      end
    end
    return nil
  end

# Retorna o objeto da Requisição com a entrada da id
  helper_method :returnReqObj
  def returnReqObj(reqId)
    #Pessoa, Endereço,Documento,Requisição
    #Pessoa.find(params[:id]).nome
    requisicao = Requisicao.find(reqId)
    return requisicao
  end

# Retorna a id da pessoa de acordo com a requisição
  helper_method :returnReqPes
  def returnReqPes(requisicao)
    return requisicao.pessoa_id
  end

# Retorna o objeto da Pessoa com a entrada objeto da Requisição
  helper_method :getPessoaByReq
  def getPessoaByReq(requisicao)
    pessoa = nil
    pessoas = Pessoa.all
    pessoas.each do |apessoa|
      if apessoa.id == requisicao.pessoa_id
        return apessoa
      end
    end
    return nil
  end

# Retorna o objeto da Pessoa com a entrada da Carteirinha
  helper_method :returnPesByCar
  def returnPesByCar(carteirinha)
    pessoa = nil

    requisicao = nil
    requisicoes  = Requisicao.all
    requisicoes.each do |arequisicao|
      if arequisicao.id == carteirinha.requisicao_id
        pessoa = getPessoaByReq(arequisicao)
        return pessoa
      end
    end
  end

# ???w
  helper_method :printAllDocuments
  def printAllDocuments(reqId)
    pessoa = Pessoa.find(requisicao.pessoa_id)
    #@endereco = Endereco.find(@requisicao.pessoa_id)
    #@documento = Document.find(@requisicao.pessoa_id)
    #@requisicao = Requisicao.find(@requisicao.pessoa_id)
    #@cid = Cid.find(@requisicao.pessoa_id)

    return pessoa.nome
  end

# Retorna o objeto Endereço de acordo com o id da Pessoa
  helper_method :returnEnderecoByPes
  def returnEnderecoByPes(pesId)
    endereco = Endereco.all
    endereco.each do |ender|
      if ender.pessoa_id == pesId
        return ender
      end
    end
    return nil
  end

# Retorna o objeto Documento de acordo com o id da Pessoa
  helper_method :returnDocumentoByPes
  def returnDocumentoByPes(pesId)
    documento = Documento.all
    documento.each do |doc|
      if doc.pessoa_id == pesId
        return doc
      end
    end
    return nil
  end

# Retorna o objeto Requisição de acordo com o id da Pessoa
  helper_method :returnRequisicaoByPes
  def returnRequisicaoByPes(pesId)
    requisicao = Requisicao.all
    requisicao.each do |req|
      if req.pessoa_id == pesId
        return req
      end
    end
    return nil
  end

  # Retorna o objeto Cid de acordo com o id da Pessoa
  helper_method :returnCiddByPes
  def returnCiddByPes(pess)
    return pess.requisicao.first.cid
  end

# Retorna o objeto Cidade de acordo com o id da Pessoa
  helper_method :returnCidByPes
  def returnCidByPes(pesId)
    cid = Cid.all
    cid.each do |cid|
      if cid.requisicao_id == returnRequisicaoByPes(pesId)
        return cid
      end
    end
    return nil
  end



# Restrição para mostrar śomente do usuario atual

  #Se está logado, não é admin e não é funcionário
  helper_method :authCurrentUsuario
  def authCurrentUsuario()
    if (usuario_signed_in?) && (!current_usuario.try(:admin?)) && (!current_usuario.try(:funcionario?))
      return true
    end
    return false
  end

  # Verifica se Pessoa atual é igual a id atual
  # Ex: pessoas/3/edit é igual ao id da Pessoa atual
  helper_method :ifCurrentPessoa
  def ifCurrentPessoa()
    if getPessoa().id == Pessoa.find(params[:id]).id
      return true
    end
    return false
  end

  helper_method :ifCurrentDocumento
  def ifCurrentDocumento()
    if returnDoc() == Documento.find(params[:id]).id
      return true
    end
    return false
  end

  helper_method :ifCurrentEndereco
  def ifCurrentEndereco()
    if returnEnd() == Endereco.find(params[:id]).id
      return true
    end
    return false
  end

  helper_method :ifCurrentRequisicao
  def ifCurrentRequisicao()
    if returnReq() == Requisicao.find(params[:id]).id
      return true
    end
    return false
  end

  helper_method :ifCurrentCarteirinha
  def ifCurrentCarteirinha()
    if returnCar() == Carteirinha.find(params[:id]).id
      return true
    end
    return false
  end

  helper_method :ifCurrentCid
  def ifCurrentCid()
    if returnCid() == Cid.find(params[:id]).id
      return true
    end
    return false
  end

  helper_method :ifInfoCarteirinha
  def ifInfoCarteirinha()
    #@iCarteirinhas = #Info_carteirinhasss.all
    #@infC
    #@iCarteirinhas.each do |ic|
    #  @infC = c
    #  break
    #end
    infC = InfoCarteirinha.all.first()
    return infC
  end

  helper_method :ifInfoCarteirinha
  def changeAndUpdateIdentificador(carteirinha)
     ic = InfoCarteirinha.first
     ic.numeracao_carteirinha = ic.numeracao_carteirinha + 1
     ic.save
     ic = InfoCarteirinha.first
     carteirinha.identificador = ic.numeracao_carteirinha
     carteirinha.save  
   end
end