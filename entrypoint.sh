#!/bin/bash

# Inicie o serviço do PostgreSQL
service postgresql start

# Aguarde até que o serviço esteja em execução
sleep 5

# Altere a senha do usuário "jc" no PostgreSQL
sudo -u postgres psql -c "ALTER USER jc WITH PASSWORD 'jc';"

# Crie o banco de dados "jc" de propriedade do usuário "jc"
sudo -u postgres createdb -O jc jc

# Inicie o aplicativo Flask
python app.py

