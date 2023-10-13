a = 5
b = 3
soma = a + b
print(soma==10)

if soma == 8:
    print('A soma é 8!')
else:
    print('A soma não é 8!')



###



for n in range (5):
    print('teste')



###



nome = input("Escreva seu nome: \n")
print('Seu nome é:', nome)


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


###


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


for i in range (5):
    print('Vou aprender!')


###


for i in range (5):
    print(i*2)


###


a = 0
for i in range (5):
    a = a + 1
print(a)


###


a = 0
b = 10
for i in range(b):
        print('Frase')


###

palavra = 'Matemática'
for i in palavra:
    print(i)


###

lista = [2,4,6,8,10,12,14,16,18,20]
for num in lista:
    print(num)

###

import time
contador = 0
while contador < 10:
    print('Ainda não deu')
    contador = contador + 1
    if contador == 6:
        break
    time.sleep(1)
print('Agora deu!')

###

numero = int(input('Digite um número: '))
fatorial = numero
contador = 1
while (numero - contador) > 1:
    fatorial = fatorial*(numero - contador)
    contador += 1
print('{0}! = {1}'.format(numero,fatorial))


###

