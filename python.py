###

# == Igual a
# != Diferente de

a = 5
b = 3
soma = a + b

# Se "soma" for igual a 10, imprimir "True"
print(soma==10)

if soma == 8:
    print('A soma é 8!')
else:
    print('A soma não é 8!')


###

pedido = input('Digite seu pedido: ')

if pedido == 'pizza':
    print('O pedido é o número 1')

elif pedido == 'lasanha':
    print('O pedido é o número 2')

elif pedido == 'panqueca':
    print('O pedido é o número 3')

else:
    print('Pedido desconhecido')


###


pedido = 'pizza'

if pedido != 'Pizza':
    print('Não é pizza!')
else:
    print('É Pizza!!!')


### Imprimir um item x vezes (0,1,2,3,4)


for i in range (5):
    print(i)


### Imprimir um item x vezes e multiplicar por 2


for i in range (5):
    print(i*2)


### Imprimir um item x vezes


for i in range (5):
    print('Vou aprender!')

##

a = 0
b = 10

for i in range(b):
    print('Frase')


##

a = 0
for i in range (5):
    a = a + 1
print(a)


## Imprimir um item verticalmente

palavra = 'Teste'
for x in palavra:
    print(x)


### Entrada do Usuário


nome = input("Escreva seu nome: \n")
print('Seu nome é:', nome)


### Maior ou Igual


ano = int(input('Em que ano você nasceu? '))
idade = 2023 - ano
if idade >= 18:
    print('Você é Adulto!!!!')
else:
    print('Você não é Adulto!!!!')


###

idade = int(input('Qual a sua idade? '))
if idade > 18:
    print('Você é Adulto!!!!')
elif idade == 18:
    print('Você acabou de se tornar Adulto!!!!')
else:
    print('Você não é Adulto!!!!')


###

lista = [2,4,6,8,10,12,14,16,18,20]
for num in lista:
    print(num)

### Contador

import time
contador = 0
while contador < 10:
    print('Ainda não deu')
    contador = contador + 1
    if contador == 6:
        break
    time.sleep(1)
print('Agora deu!')


## Contador 2

import time

contador = 1

while contador <= 10:
    print(contador)
    contador += 1
    time.sleep(1)  # Espera por 1 segundo (intervalo de tempo entre as contagens)



### Factorial

import math

# Número para o qual você quer calcular o fatorial
numero = 5

# Calcula o fatorial usando a função factorial do módulo math
resultado = math.factorial(numero)

print(f'O fatorial de {numero} é {resultado}')


### Datetime


import datetime

# Obtém a data e hora atuais
data_e_hora_atual = datetime.datetime.now()

# Imprime a data e hora atual
print("Data e hora atuais:", data_e_hora_atual)


### Lista


lista1 = [1, 2, 3]

lista2 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

#select = lista2[0]

#select = lista2[0][1]

select = lista2[0][2]

print(select)


### Random


import random

# Escolhe aleatoriamente um item de uma lista
lista = [1, 2, 3, 4, 5]
item_aleatorio = random.choice(lista)
print("Item aleatório da lista:", item_aleatorio)

# Embaralha a ordem dos elementos em uma lista
random.shuffle(lista)
print("Lista embaralhada:", lista)

# Escolhe aleatoriamente múltiplos itens de uma lista sem repetição
itens_aleatorios = random.sample(lista, 2)
print("Itens aleatórios sem repetição:", itens_aleatorios)


### Funções

## Se um item estiver presente dentro de uma frase ou algo do tipo...


def temLetraU():

    frase = input('Digite uma Frase: ')
    if 'u' in frase:
        print('Você utilizou a letra U')
    else:
        print('Você não utilizou a letra U')
