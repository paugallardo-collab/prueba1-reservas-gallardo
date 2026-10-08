# Feature Specification: Reservas de sala

**Created**: 2026-10-01
**Status**: Draft

## User Scenarios & Testing

### User Story 1 — Reservar una sala (Priority: P1)

Como estudiante autenticado, quiero reservar una sala de estudio por un intervalo de tiempo
para tener dónde trabajar con mi grupo.

**Why this priority**: sin reservas, la app no tiene propósito.

**Independent Test**: se puede probar creando una reserva y comprobando que queda registrada.

**Acceptance Scenarios**:

1. **Dado** que la sala A está libre, **Cuando** reservo de 09:00 a 10:00, **Entonces** la
   reserva queda registrada a mi nombre.
2. **Dado** que elijo como inicio las 10:00 y como fin las 09:00, **Cuando** intento reservar,
   **Entonces** la reserva se rechaza con el mensaje `La hora de fin debe ser posterior a la de inicio`.
3. **Dado** que la sala A ya está reservada de 09:00 a 10:00, **Cuando** intento reservarla de
   08:30 a 09:30, **Entonces** la reserva se rechaza con el mensaje
   `La sala ya está reservada en ese horario`.
4. **Dado** que la sala A ya está reservada de 09:00 a 10:00, **Cuando** intento reservarla de
   09:30 a 10:30, **Entonces** la reserva se rechaza con el mensaje
   `La sala ya está reservada en ese horario`.
5. **Dado** que la sala A ya está reservada de 09:00 a 10:00, **Cuando** intento reservarla de
   08:00 a 11:00, **Entonces** la reserva se rechaza con el mensaje
   `La sala ya está reservada en ese horario`.
6. **Dado** que la sala A ya está reservada de 09:00 a 10:00, **Cuando** la reservo de 10:00 a
   11:00, **Entonces** la nueva reserva queda registrada.
7. **Dado** que la sala A está reservada de 09:00 a 10:00 y la sala B está libre, **Cuando**
   reservo la sala B de 09:00 a 10:00, **Entonces** la reserva queda registrada.

### Edge Cases

- Cualquier tiempo compartido entre dos reservas de la misma sala hace que la nueva reserva se
  rechace, incluso si el solapamiento es parcial o una reserva contiene por completo a la otra.
- Dos reservas de la misma sala pueden ser consecutivas si la hora de fin de una coincide con la
  hora de inicio de la otra.
- Reservas de salas distintas pueden cubrir el mismo intervalo.

## Requirements

### Functional Requirements

- **FR-001**: El estudiante puede elegir una sala, una hora de inicio y una hora de fin.
- **FR-002**: La hora de fin debe ser posterior a la hora de inicio.
- **FR-003**: Una reserva solo puede registrarse si no comparte tiempo con otra reserva de la
  misma sala.
- **FR-004**: Si una reserva comparte tiempo con otra de la misma sala, se rechaza con el mensaje
  exacto `La sala ya está reservada en ese horario`.
- **FR-005**: La coincidencia de la hora de fin de una reserva con la hora de inicio de otra no
  constituye solapamiento.
- **FR-006**: Las reservas de salas distintas no se bloquean entre sí por coincidir en el tiempo.

### Key Entities

- **Reserva**: sala, estudiante, hora de inicio y hora de fin.
- **Sala**: identificada por su nombre (Sala A, Sala B, Sala C).

## Success Criteria

- **SC-001**: Un estudiante completa una reserva en menos de 30 segundos.
