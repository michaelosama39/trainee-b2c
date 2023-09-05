import 'package:injectable/injectable.dart';

import '../../../../core/entities/acknowledge_entity.dart';
import '../../../../core/errors/app_errors.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/model/request/change_password_request.dart';
import '../../data/model/request/create_feedback_request.dart';
import '../repository/iaccount_repository.dart';

@injectable
class CreateFeedbackUseCase
    extends UseCase<AcknowledgeEntity, CraeteFeedbackRequest> {
  final IAccountRepository accountRepository;

  CreateFeedbackUseCase(this.accountRepository);

  @override
  Future<Result<AppErrors, AcknowledgeEntity>> call(
          CraeteFeedbackRequest params) async =>
      await accountRepository.createFeedback(params);
}
