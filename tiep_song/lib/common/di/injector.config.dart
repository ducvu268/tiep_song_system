// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tiep_song/common/config/app_config.dart' as _i131;
import 'package:tiep_song/common/network/api_client.dart' as _i765;
import 'package:tiep_song/common/services/connectivity_service.dart' as _i559;
import 'package:tiep_song/common/services/location_service.dart' as _i700;
import 'package:tiep_song/common/services/mesh_service.dart' as _i954;
import 'package:tiep_song/features/settings/data/datasources/settings_local_datasource.dart'
    as _i152;
import 'package:tiep_song/features/settings/data/repositories/settings_repository_impl.dart'
    as _i672;
import 'package:tiep_song/features/settings/domain/repository/settings_repository.dart'
    as _i217;
import 'package:tiep_song/features/settings/domain/usecases/get_emergency_contact_usecase.dart'
    as _i102;
import 'package:tiep_song/features/settings/domain/usecases/save_emergency_contact_usecase.dart'
    as _i1005;
import 'package:tiep_song/features/settings/presentation/bloc/settings/settings_bloc.dart'
    as _i789;
import 'package:tiep_song/features/sos/data/datasources/sos_local_datasource.dart'
    as _i1064;
import 'package:tiep_song/features/sos/data/datasources/sos_mesh_datasource.dart'
    as _i428;
import 'package:tiep_song/features/sos/data/datasources/sos_remote_datasource.dart'
    as _i16;
import 'package:tiep_song/features/sos/data/repositories/sos_repository_impl.dart'
    as _i570;
import 'package:tiep_song/features/sos/domain/repository/sos_repository.dart'
    as _i473;
import 'package:tiep_song/features/sos/domain/services/sos_background_sync.dart'
    as _i476;
import 'package:tiep_song/features/sos/domain/usecases/get_sos_history_usecase.dart'
    as _i802;
import 'package:tiep_song/features/sos/domain/usecases/send_sos_usecase.dart'
    as _i714;
import 'package:tiep_song/features/sos/domain/usecases/sync_pending_sos_usecase.dart'
    as _i29;
import 'package:tiep_song/features/sos/domain/usecases/watch_incoming_sos_usecase.dart'
    as _i409;
import 'package:tiep_song/features/sos/presentation/bloc/sos/sos_bloc.dart'
    as _i519;
import 'package:tiep_song/features/sos/presentation/bloc/sos_list/sos_list_bloc.dart'
    as _i582;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i152.SettingsLocalDataSource>(
        () => _i152.SettingsLocalDataSource());
    gh.factory<_i1064.SosLocalDataSource>(() => _i1064.SosLocalDataSource());
    gh.lazySingleton<_i700.LocationService>(() => _i700.LocationService());
    gh.lazySingleton<_i954.MeshService>(() => _i954.MeshService());
    gh.lazySingleton<_i559.ConnectivityService>(
        () => _i559.ConnectivityService());
    gh.factory<_i428.SosMeshDataSource>(
        () => _i428.SosMeshDataSource(gh<_i954.MeshService>()));
    gh.lazySingleton<_i765.ApiClient>(
        () => _i765.ApiClient(gh<_i131.AppConfig>()));
    gh.factory<_i16.SosRemoteDataSource>(
        () => _i16.SosRemoteDataSource(gh<_i765.ApiClient>()));
    gh.factory<_i217.SettingsRepository>(() =>
        _i672.SettingsRepositoryImpl(gh<_i152.SettingsLocalDataSource>()));
    gh.factory<_i473.SosRepository>(() => _i570.SosRepositoryImpl(
          localDataSource: gh<_i1064.SosLocalDataSource>(),
          meshDataSource: gh<_i428.SosMeshDataSource>(),
          remoteDataSource: gh<_i16.SosRemoteDataSource>(),
        ));
    gh.factory<_i1005.SaveEmergencyContactUseCase>(() =>
        _i1005.SaveEmergencyContactUseCase(gh<_i217.SettingsRepository>()));
    gh.factory<_i102.GetEmergencyContactUseCase>(
        () => _i102.GetEmergencyContactUseCase(gh<_i217.SettingsRepository>()));
    gh.factory<_i802.GetSosHistoryUseCase>(
        () => _i802.GetSosHistoryUseCase(gh<_i473.SosRepository>()));
    gh.factory<_i29.SyncPendingSosUseCase>(
        () => _i29.SyncPendingSosUseCase(gh<_i473.SosRepository>()));
    gh.factory<_i714.SendSosUseCase>(
        () => _i714.SendSosUseCase(gh<_i473.SosRepository>()));
    gh.factory<_i409.WatchIncomingSosUseCase>(
        () => _i409.WatchIncomingSosUseCase(gh<_i473.SosRepository>()));
    gh.lazySingleton<_i476.SosBackgroundSync>(() => _i476.SosBackgroundSync(
          repository: gh<_i473.SosRepository>(),
          connectivityService: gh<_i559.ConnectivityService>(),
          syncPendingSosUseCase: gh<_i29.SyncPendingSosUseCase>(),
        ));
    gh.factory<_i789.SettingsBloc>(() => _i789.SettingsBloc(
          getEmergencyContactUseCase: gh<_i102.GetEmergencyContactUseCase>(),
          saveEmergencyContactUseCase: gh<_i1005.SaveEmergencyContactUseCase>(),
        ));
    gh.factory<_i582.SosListBloc>(() => _i582.SosListBloc(
          getSosHistoryUseCase: gh<_i802.GetSosHistoryUseCase>(),
          watchIncomingSosUseCase: gh<_i409.WatchIncomingSosUseCase>(),
        ));
    gh.factory<_i519.SosBloc>(() => _i519.SosBloc(
          sendSosUseCase: gh<_i714.SendSosUseCase>(),
          locationService: gh<_i700.LocationService>(),
          getEmergencyContactUseCase: gh<_i102.GetEmergencyContactUseCase>(),
        ));
    return this;
  }
}
