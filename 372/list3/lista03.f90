PROGRAM LISTA03
    IMPLICIT NONE
    INTEGER :: I, J, K, KK, N = 512
    REAL :: T1, T2
    DOUBLE PRECISION :: TEMP0, TEMP1, TEMP2, TEMP3
    DOUBLE PRECISION, DIMENSION(1:512,1:512) :: A, B, C

    ! Inicializa
    DO J = 1, N
        DO I = 1, N
            A(I,J) = 3*I + 4*J
            B(I,J) = 5*I + 6*J
            C(I,J) = 7*I + 8*J
        ENDDO
    ENDDO

    ! Multiplicação de matrizes
    CALL CPU_TIME(T1)
    DO K = 1, N
        DO J = 1, N
            DO I = 1, N
                C(I,J) = C(I,J) + A(I,K)*B(K,J)
            ENDDO
        ENDDO
    ENDDO
    CALL CPU_TIME(T2)
    PRINT*, 'Multiplicação: ', (T2-T1), 's'
    ! Verificando alguns resultados
    DO I = 1, 3
        PRINT*, C(I, 1)
    ENDDO

    ! Inicializa
    DO J = 1, N
        DO I = 1, N
            A(I,J) = 3*I + 4*J
            B(I,J) = 5*I + 6*J
            C(I,J) = 7*I + 8*J
        ENDDO
    ENDDO

    ! PASSO I: Permutar os loops mais externos
    CALL CPU_TIME(T1)
    DO J = 1, N
        DO I = 1, N
            DO K = 1, N
                C(I,J) = C(I,J) + A(I,K)*B(K,J)
            ENDDO
        ENDDO
    ENDDO
    CALL CPU_TIME(T2)
    PRINT*, 'Permutação:    ', (T2-T1), 's'
    ! Verificando alguns resultados
    DO I = 1, 3
        PRINT*, C(I, 1)
    ENDDO

    ! Inicializa
    DO J = 1, N
        DO I = 1, N
            A(I,J) = 3*I + 4*J
            B(I,J) = 5*I + 6*J
            C(I,J) = 7*I + 8*J
        ENDDO
    ENDDO

    ! PASSO II: Loop unrolling
    CALL CPU_TIME(T1)
    DO J = 1, N
        DO I = 1, N

            KK = MOD(N, 4)
            DO K = 1, KK
                C(I,J) = C(I,J) + A(I,K)*B(K,J)
            ENDDO

            TEMP0 = 0.0
            TEMP1 = 0.0
            TEMP2 = 0.0
            TEMP3 = 0.0
            DO K = 1+KK, N, 4
                TEMP0 = TEMP0 + A(I,K)*B(K,J)
                TEMP1 = TEMP1 + A(I,K+1)*B(K+1,J)
                TEMP2 = TEMP2 + A(I,K+2)*B(K+2,J)
                TEMP3 = TEMP3 + A(I,K+3)*B(K+3,J)
            ENDDO
            C(I,J) = C(I,J)+TEMP0+TEMP1+TEMP2+TEMP3
        ENDDO
    ENDDO
    CALL CPU_TIME(T2)
    PRINT*, 'Loop unrolling:', (T2-T1), 's'
    ! Verificando alguns resultados
    DO I = 1, 3
        PRINT*, C(I, 1)
    ENDDO

END PROGRAM LISTA03
