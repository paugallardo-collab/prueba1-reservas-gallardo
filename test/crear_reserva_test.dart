import 'package:flutter_test/flutter_test.dart';
import 'package:reservas_sala/domain/crear_reserva.dart';
import 'package:reservas_sala/domain/reserva.dart';

import 'support/reservas_en_memoria.dart';

DateTime hora(int h, [int m = 0]) => DateTime(2026, 10, 14, h, m);

void main() {
  late ReservasEnMemoria repositorio;
  late CrearReserva crearReserva;

  setUp(() {
    repositorio = ReservasEnMemoria();
    crearReserva = CrearReserva(repositorio);
  });

  Future<void> registrarReservaExistente({
    required String salaId,
    required int inicio,
    required int fin,
  }) async {
    await repositorio.guardar(SolicitudReserva(
      salaId: salaId,
      usuarioId: 'u0',
      inicio: hora(inicio),
      fin: hora(fin),
    ));
  }

  test('acepta una reserva válida y la guarda', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(9),
      fin: hora(10),
    ));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva cuyo fin no es posterior al inicio', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(10),
      fin: hora(9),
    ));

    expect(resultado.aceptada, isFalse);
    expect(
        resultado.mensaje, 'La hora de fin debe ser posterior a la de inicio');
    expect(repositorio.reservas, isEmpty);
  });

  test('rechaza un solapamiento que empieza antes de la reserva existente',
      () async {
    await registrarReservaExistente(salaId: 'Sala A', inicio: 9, fin: 10);

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(8, 30),
      fin: hora(9, 30),
    ));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario');
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza un solapamiento que termina después de la reserva existente',
      () async {
    await registrarReservaExistente(salaId: 'Sala A', inicio: 9, fin: 10);

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(9, 30),
      fin: hora(10, 30),
    ));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario');
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva completamente contenida en otra', () async {
    await registrarReservaExistente(salaId: 'Sala A', inicio: 8, fin: 12);

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(9),
      fin: hora(10),
    ));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario');
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva que contiene por completo a otra', () async {
    await registrarReservaExistente(salaId: 'Sala A', inicio: 9, fin: 10);

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(8),
      fin: hora(11),
    ));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La sala ya está reservada en ese horario');
    expect(repositorio.reservas, hasLength(1));
  });

  test('acepta reservas consecutivas cuando solo comparten el límite',
      () async {
    await registrarReservaExistente(salaId: 'Sala A', inicio: 9, fin: 10);

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(10),
      fin: hora(11),
    ));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(2));
  });

  test('permite el mismo horario cuando la sala es distinta', () async {
    await registrarReservaExistente(salaId: 'Sala A', inicio: 9, fin: 10);

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala B',
      usuarioId: 'u1',
      inicio: hora(9),
      fin: hora(10),
    ));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(2));
  });
}
