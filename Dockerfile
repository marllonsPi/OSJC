# Use a imagem oficial do Python como imagem base
FROM python:3.9

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos necessários para o contêiner
COPY . /app

# Instale as dependências do seu aplicativo
RUN pip install --no-cache-dir -r requirements.txt

# Copie o script de inicialização do contêiner
COPY entrypoint.sh /app

# Configure a variável de ambiente para a conexão com o banco de dados
ENV SQLALCHEMY_DATABASE_URI=postgresql://jc:jc@localhost/jc




# Exponha a porta do aplicativo Flask
EXPOSE 5000

VOLUME /app/data

# Defina o script de inicialização como o ponto de entrada do contêiner
ENTRYPOINT ["/app/entrypoint.sh"]

