from flask import Flask, render_template, current_app, request, redirect, url_for, flash
from datetime import date
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import relationship
from sqlalchemy import Numeric
from sqlalchemy import func
from flask_wtf import FlaskForm
from werkzeug.exceptions import abort
import os
import locale


app = Flask(__name__)
locale.setlocale(locale.LC_ALL, 'pt_BR.utf-8')
app.jinja_env.globals.update(
    format_currency=lambda value: locale.currency(value, grouping=True).replace(' ', '')
)
app.secret_key = 'jcacabamentos'
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://jc:jc@localhost/jc'
db = SQLAlchemy(app)
def format_currency(value):
    return '{:,.2f}'.format(value).replace(',', 'X').replace('.', ',').replace('X', '.')





class OrdemDeServico(db.Model):
    __tablename__ = 'ordem_de_servico'

    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.Date, nullable=False)
    descricao = db.Column(db.String(255))
    cliente_id = db.Column(db.Integer, db.ForeignKey('clientes.id'))  # Adicione a chave estrangeira
    titulo_servico = db.Column(db.String(100), nullable=False)
    valor_cobrado = db.Column(Numeric(precision=12, scale=2), nullable=False)
    forma_pagamento = db.Column(db.String(50), nullable=False)
    nome_cliente = db.Column(db.String(100), nullable=False)
    cliente = db.relationship('Cliente', backref='ordens_de_servico')







class Cliente(db.Model):
    __tablename__ = 'clientes'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    nome = db.Column(db.String(100))
    endereco = db.Column(db.String(100))
    telefone = db.Column(db.String(20))
  






@app.route('/')
def index():
    ordens_de_servico = OrdemDeServico.query.order_by(OrdemDeServico.data.desc()).limit(10).all()
    ordens_de_servico_reverso = list(reversed(ordens_de_servico))
    return render_template('index.html', ordens_de_servico=ordens_de_servico_reverso)





@app.route('/nova_os', methods=['GET', 'POST'])
def nova_os():
    if request.method == 'POST':
        data = request.form['data']
        cliente_id = request.form['cliente_id']
        titulo_servico = request.form['titulo_servico']
        descricao = request.form['descricao']
        valor_cobrado = request.form['valor_cobrado']
        forma_pagamento = request.form['forma_pagamento']

        # Encontrar o cliente correspondente
        cliente = Cliente.query.get(cliente_id)
        nome_cliente = cliente.nome if cliente else ''

        os = OrdemDeServico(
            data=data,
            descricao=descricao,
            cliente_id=cliente_id,  # Corrigido o nome do argumento
            titulo_servico=titulo_servico,
            valor_cobrado=valor_cobrado,
            forma_pagamento=forma_pagamento,
            nome_cliente=nome_cliente
        )

        db.session.add(os)
        db.session.commit()
        flash('Ordem de serviço adicionada com sucesso.')
        return redirect(url_for('index'))
    else:
        clientes = Cliente.query.all()
        return render_template('nova_os.html', clientes=clientes)





@app.route('/os/<int:id>')
def ordem_de_servico(id):
    os = OrdemDeServico.query.get_or_404(id)
    os.valor_cobrado_formatado = locale.currency(os.valor_cobrado, grouping=True).replace(' ', '')

    return render_template('ordem_de_servico.html', os=os)




@app.route('/relatorios', methods=['GET', 'POST'])
def relatorios():
    if request.method == 'POST':
        data_inicio = request.form.get('data_inicio')
        data_fim = request.form.get('data_fim')
        cliente_id = request.form.get('cliente_id')

        query = db.session.query(OrdemDeServico)
        if data_inicio:
            query = query.filter(OrdemDeServico.data >= data_inicio)
        if data_fim:
            query = query.filter(OrdemDeServico.data <= data_fim)
        if cliente_id:
            query = query.join(Cliente).filter(Cliente.id == cliente_id)

        resultados = query.all()

        # Calcula a soma dos valores
        soma_valores = db.session.query(func.sum(OrdemDeServico.valor_cobrado)).filter(OrdemDeServico.id.in_([resultado.id for resultado in resultados])).scalar()

        # Formata a soma dos valores para exibição
        soma_valores_formatado = format_currency(soma_valores) if soma_valores is not None else '0,00'

        # Adiciona a propriedade formatada aos resultados
        for resultado in resultados:
            resultado.valor_cobrado_formatado = format_currency(resultado.valor_cobrado)

        return render_template('relatorios.html', resultados=resultados, soma_valores_formatado=soma_valores_formatado)
    else:
        return render_template('index.html')
    


@app.route('/indexrelatorio')
def indexrelatorio():
    # Consulta todos os clientes no banco de dados
    clientes = Cliente.query.all()
    
    # Renderiza a página indexrelatorio.html e passa os dados necessários como argumentos
    return render_template('indexrelatorio.html', clientes=clientes)



@app.route('/editar_os/<int:id>', methods=['GET', 'POST'])
def editar_os(id):
    os = OrdemDeServico.query.get_or_404(id)
    if request.method == 'POST':
        os.valor_cobrado = request.form['valor_cobrado']
        os.descricao = request.form['descricao']
        os.forma_pagamento = request.form['forma_pagamento']
        os.titulo_servico = request.form['titulo_servico']
        db.session.commit()
        flash('Ordem de serviço atualizada com sucesso.')
        return redirect(url_for('ordem_de_servico', id=id))
    else:
        return render_template('editar_os.html', os=os)




@app.route('/remover_os/<int:id>', methods=['GET', 'POST', 'DELETE'])
def remover_os(id):
    if request.method == 'GET':
        return render_template('confirmar_remocao.html', id=id)
    elif request.method == 'POST' or request.method == 'DELETE':
        os = OrdemDeServico.query.get_or_404(id)
        db.session.delete(os)
        db.session.commit()
        flash('A ordem de serviço foi removida com sucesso.')
        return redirect(url_for('index'))
    else:
        abort(405)  # Retorna o erro 405 (Method Not Allowed) para outros métodos não suportados





@app.route('/clientes')
def clientes(): 
    clientes = Cliente.query.order_by(Cliente.id).all()
    return render_template('clientes.html', clientes=clientes)


@app.route('/remover_cliente/<int:id>', methods=['POST'])
def remover_cliente(id):
    cliente = Cliente.query.get_or_404(id)
    db.session.delete(cliente)
    db.session.commit()
    flash('Cliente removido com sucesso.')
    return redirect(url_for('clientes'))


@app.route('/adicionar_cliente', methods=['POST'])
def adicionar_cliente():
    nome = request.form['nome_cliente']
    endereco = request.form['endereco']
    telefone = request.form['telefone']
    cliente = Cliente(nome=nome, endereco=endereco, telefone=telefone)
    db.session.add(cliente)
    db.session.commit()
    flash('Cliente adicionado com sucesso.')
    return redirect(url_for('clientes'))


@app.route('/add_cliente', methods=['GET', 'POST'])
def add_cliente():
    if request.method == 'POST':
        nome = request.form['nome_cliente']
        endereco = request.form['endereco']
        telefone = request.form['telefone']
        cliente = Cliente(nome=nome, endereco=endereco, telefone=telefone)
        db.session.add(cliente)
        db.session.commit()
        flash('Cliente adicionado com sucesso.')
        return redirect(url_for('clientes'))
    else:
        return render_template('add_cliente.html')


if __name__ == '__main__':
    app.run(host='localhost', debug=True)

