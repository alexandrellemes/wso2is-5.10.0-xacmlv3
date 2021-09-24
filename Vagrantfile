# -*- mode: ruby -*-
# vi: set ft=ruby :

# Alerta para instalação e configuração do plugin vbguest para atualização do
# VirtualBox Guest Additions
unless Vagrant.has_plugin?("vagrant-vbguest")
  warn "\n\n**********************************************************\n\n"+
       "                          ATENÇAO !!!                        \n\n"+
       "Não foi localizado o plugin vagrant-vbguest na máquina host. \n\n"+
       "Recomendamos seu uso para evitar incompatibilidades de versões \n"+
       "entre o Virtualbox e VBGuest Addition, impactando o          \n"+
       "compartilhamento de pastas. \n\n"+
       "Para solucionar o problema, execute o seguinte comando no \n"+
       "diretório raiz do projeto. \n\n"+
       "> vagrant plugin install vagrant-vbguest                     \n"+
       "\n********************************************************** \n\n"+
       " Pressione ENTER para continuar ou (Ctrl + C) para finalizar ... \n\n"

  $stdin.gets; puts "\n"
end

Vagrant.configure(2) do |config|
  ## Instalação de plugin para configuração automática do disco
  required_plugins = %w( vagrant-vbguest vagrant-disksize vagrant-env)
  _retry = false
  required_plugins.each do |plugin|
    unless Vagrant.has_plugin? plugin
      system "vagrant plugin install #{plugin}"
      _retry=true
    end
  end

  if (_retry)
    exec "vagrant " + ARGV.join(' ')
  end

  # Box do vagrant contendo o ambiente de desenvolvimento do SEI
#   config.vm.box = "{{.BoxName}}"
  config.vm.box = "bento/ubuntu-20.04"
  config.env.enable # Enable vagrant-env(.env)

  config.disksize.size = "30GB"
  config.vbguest.auto_update = true
  config.vbguest.no_remote = false
  config.vbguest.iso_mount_point = "/media"
  config.vbguest.installer_options = { allow_kernel_upgrade: true }

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", ENV['APP_MEMORY'], "--usb", "off", "--audio", "none"]
  end

  # Configuração do diretório local para o projeto.
  config.vm.synced_folder ".", "/opt/wso2", mount_options: ["dmode=777", "fmode=777"]

  # Configuração do redirecionamento entre Máquina Virtual e Host
  config.vm.network :forwarded_port, guest: 4000, host: 4000
  config.vm.network :forwarded_port, guest: 9443, host: 9443
  config.vm.network :forwarded_port, guest: 9763, host: 9763

  config.vm.provision "install-docker", type: "shell", path: "./install-docker.sh"
  config.vm.provision "install-docker-compose", type: "shell", path: "./install-docker-compose.sh"
  config.vm.provision "install-docker-machines", type: "shell", path: "./run.sh"

  config.vm.post_up_message = <<-EOF

=========================================================================
  INICIALIZAÇÃO DO AMBIENTE DE DESENVOLVIMENTO FINALIZADA COM SUCESSO !
=========================================================================

= Endereços de Acesso à Aplicação ========================================
SEI ........................... http://localhost:8000/sei
SIP ........................... http://localhost:8000/sip

Acesso de Usuário Externo ..... [SEI]/controlador_externo.php?acao=usuario_externo_logar&id_orgao_acesso_externo=0
Autenticidade de Documentos ... [SEI]/controlador_externo.php?acao=documento_conferir&id_orgao_acesso_externo=0
Publicações Eletrônicas ....... [SEI]/publicacoes/controlador_publicacoes.php?acao=publicacao_pesquisar&id_orgao_publicacao=0
WSDL de integração do SEI ..... [SEI]/ws/SeiWS.php
PHP Info ...................... http://localhost:8000/info.php

= Outros Serviços ========================================================
Solr .......................... http://localhost:8983/solr
MailCatcher ................... http://localhost:1080
Mysql ......................... localhost:3306
Oracle ........................ localhost:1521
SQLServer ..................... localhost:1433

= Comandos Úteis =========================================================
vagrant up                        - Inicializar ambiente do SEI
vagrant halt                      - Desligar ambiente
vagrant destroy                   - Destruir ambiente e base de testes
vagrant ssh                       - Acessar máquina virtual
vagrant status                    - Verificar situação atual do ambiente

Utilize o parâmetro '--provision-with' para alterar o banco de dados padrão:

vagrant up --provision-with [mysql|oracle|sqlserver]
-- ou --
vagrant provision --provision-with [mysql|oracle|sqlserver]

= Debug =========================================================
PHP xDebug3
Porta: 9003

EOF
end
