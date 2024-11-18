    .data
msg_prompt: .asciz "Ingresa la temperatura en Celsius: " // Mensaje para solicitar la temperatura en Celsius
msg_result: .asciz "La temperatura en Fahrenheit es: %.2f\n" // Mensaje para imprimir el resultado en Fahrenheit
fmt_float: .asciz "%lf" // Formato para leer flotantes
factor: .double 1.8 // Constante 9/5
addend: .double 32.0 // Constante 32

    .text
    .global main

main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]! // Reservar espacio en la pila
    mov x29, sp // Establecer el puntero de marco
    sub sp, sp, #16 // Reservar espacio para la temperatura en Celsius (double, 8 bytes)

    // Solicitar la temperatura en Celsius
    ldr x0, =msg_prompt // Cargar el mensaje para la temperatura en Celsius
    bl printf // Imprimir el mensaje
    ldr x0, =fmt_float // Cargar el formato para leer un número de punto flotante
    mov x1, sp // Dirección donde se guardará la temperatura en Celsius en la pila
    bl scanf // Leer la temperatura en Celsius (double) desde el usuario

    // Cargar la temperatura en Celsius desde la pila
    ldr d0, [sp] // Cargar la temperatura en Celsius en d0 (double)

    // Realizar la conversión a Fahrenheit: F = C * (9/5) + 32
    ldr x1, =factor // Cargar la dirección de factor (1.8) en x1
    ldr d1, [x1]    // Cargar el valor 1.8 en d1 desde la memoria
    fmul d2, d0, d1 // Multiplicar Celsius por 9/5 -> d2 = C * (9/5)
    ldr x2, =addend // Cargar la dirección de addend (32) en x2
    ldr d3, [x2]    // Cargar el valor 32 en d3 desde la memoria
    fadd d2, d2, d3 // Sumar 32 al resultado -> d2 = C * (9/5) + 32

    // Imprimir el resultado
    ldr x0, =msg_result // Cargar el mensaje de resultado
    fmov d0, d2 // Mover el resultado (Fahrenheit) a d0 para printf
    bl printf // Imprimir la temperatura en Fahrenheit

    // Restaurar el puntero de pila y regresar
    add sp, sp, #16 // Restaurar el puntero de pila
    ldp x29, x30, [sp], 16 // Restaurar el puntero de marco y el enlace de retorno
    ret // Regresar del programa
