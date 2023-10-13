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

