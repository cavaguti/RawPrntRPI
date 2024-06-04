#!/bin/sh

# Exibe mensagem de instalação das dependências necessárias
echo "Installing needed dependencies"

# Instala os pacotes necessários
sudo apt install cups xinetd -y

# Inicia e habilita o serviço do CUPS
sudo systemctl start cups
sudo systemctl enable cups

# Abre a página do CUPS no navegador padrão (esta linha pode variar conforme o sistema)
xdg-open http://localhost:631

# Solicita o nome da impressora ao usuário
read -p "Insira o nome da impressora que você deseja compartilhar, igual ao que está no CUPS: " impressora

# Adiciona a definição do serviço JetDirect ao final do arquivo /etc/services
echo "jetdirect 9100/tcp" | sudo tee -a /etc/services

# Exibe mensagem de início da instalação da impressora
echo "Starting Printer Installation..."

# Cria o arquivo de configuração para o serviço JetDirect
sudo tee /etc/xinetd.d/jetdirect > /dev/null <<EOL
service jetdirect {
    socket_type = stream
    protocol = tcp
    wait = no
    user = root
    server = /usr/bin/lp
    server_args = -d $impressora -o raw
    groups = yes
    disable = no
}
EOL

# Reinicia o serviço xinetd
sudo systemctl restart xinetd





