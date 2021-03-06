import Library
import KsApi
import Prelude
import Prelude_UIKit
import UIKit

internal final class ProjectActivityLaunchCell: UITableViewCell, ValueCell {
  private let viewModel: ProjectActivityLaunchCellViewModelType = ProjectActivityLaunchCellViewModel()

  @IBOutlet private weak var cardView: UIView!
  @IBOutlet private weak var titleLabel: UILabel!

  internal func configureWith(value activityAndProject: (Activity, Project)) {
    self.viewModel.inputs.configureWith(activity: activityAndProject.0,
                                        project: activityAndProject.1)
  }

  internal override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.title.observeForUI()
      .observeNext { [weak titleLabel] title in
        guard let titleLabel = titleLabel else { return }

        titleLabel.attributedText = title.simpleHtmlAttributedString(font: .ksr_body(),
          bold: UIFont.ksr_body().bolded,
          italic: nil
        )

        titleLabel
          |> projectActivityStateChangeLabelStyle
          |> UILabel.lens.textColor .~ .ksr_text_navy_700
    }
  }

  internal override func bindStyles() {
    super.bindStyles()

    self
      |> baseTableViewCellStyle()
      |> ProjectActivityLaunchCell.lens.contentView.layoutMargins %~~ { layoutMargins, cell in
        cell.traitCollection.isRegularRegular
          ? projectActivityRegularRegularLayoutMargins
          : layoutMargins
      }
      |> UITableViewCell.lens.accessibilityHint %~ { _ in Strings.Opens_project() }

    self.cardView
      |> cardStyle()
      |> dropShadowStyle()
      |> UIView.lens.layer.borderColor .~ UIColor.ksr_navy_700.CGColor
  }
}
