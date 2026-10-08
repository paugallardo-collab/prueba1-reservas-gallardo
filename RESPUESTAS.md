## Escenarios que elegí y por qué

Elegí los solapamientos parciales desde ambos extremos (`specs/001-reservas-sala/spec.md:23`, `specs/001-reservas-sala/spec.md:26`) y la contención (`specs/001-reservas-sala/spec.md:29`) para cubrir intervalos que se cruzan de distintas formas. Añadí el límite consecutivo (`specs/001-reservas-sala/spec.md:32`) y una sala distinta (`specs/001-reservas-sala/spec.md:34`) para dejar claros los casos permitidos. Las pruebas comprueban el rechazo, el mensaje exacto y que no se guarde una segunda reserva (`test/crear_reserva_test.dart:68`, `test/crear_reserva_test.dart:69`, `test/crear_reserva_test.dart:70`).

## Riesgo más grave del repositorio

La pantalla permite editar el ID de usuario (`lib/presentation/reserva_page.dart:88`) y lo envía como propietario de la reserva (`lib/presentation/reserva_page.dart:62`). La política de inserción acepta cualquier fila de una sesión autenticada (`supabase/migracion.sql:23`, `supabase/migracion.sql:24`), sin comprobar que `usuario_id` sea el usuario autenticado; alguien podría atribuir una reserva a otro usuario si conoce su ID.

## ¿La regla protege la app real?

No. `CrearReserva` consulta las reservas de la sala y detecta intervalos cruzados (`lib/domain/crear_reserva.dart:17`, `lib/domain/crear_reserva.dart:20`), pero la pantalla inserta directamente en Supabase (`lib/presentation/reserva_page.dart:60`). La base solo comprueba que el fin sea posterior al inicio (`supabase/migracion.sql:11`) y no tiene una restricción contra solapamientos. Por eso el flujo real y las escrituras concurrentes pueden incumplir la regla.