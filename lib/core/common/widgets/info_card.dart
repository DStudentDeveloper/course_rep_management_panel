import 'package:course_rep_management_panel/core/utils/core_utils.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:gap/gap.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({
    this.infoText,
    this.child,
    super.key,
    this.onTap,
    this.onEdit,
    this.onDelete,
  })  : assert(
          infoText != null || child != null,
          'infoText or child must be provided',
        ),
        assert(
          infoText == null || child == null,
          'infoText and child cannot be provided at the same time',
        );

  final String? infoText;
  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  final controlsController = OverlayPortalController();
  final link = LayerLink();

  @override
  void initState() {
    super.initState();
    controlsController.show();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: AspectRatio(
              aspectRatio: 1,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: widget.child ??
                      Center(
                        child: Text(
                          widget.infoText!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Center(
              child: OverlayPortal(
                controller: controlsController,
                child: CompositedTransformTarget(link: link),
                overlayChildBuilder: (_) {
                  return Center(
                    child: CompositedTransformFollower(
                      link: link,
                      followerAnchor: Alignment.center,
                      showWhenUnlinked: false,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.onEdit != null)
                            IconButton.filled(
                              padding: const EdgeInsets.all(10),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: widget.onEdit,
                            ),
                          if (widget.onDelete != null) ...[
                            if (widget.onEdit != null) const Gap(10),
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              padding: const EdgeInsets.all(10),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                CoreUtils.showConfirmationDialog(
                                  context: context,
                                  title: 'Delete',
                                  message: 'Are you sure you want to delete '
                                      'this item?',
                                  onConfirm: widget.onDelete!,
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
