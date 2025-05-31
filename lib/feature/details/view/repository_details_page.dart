import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inno_boon_interview/model/github_projects_model.dart';
import 'package:inno_boon_interview/feature/details/viewModel/repository_detail_screen_cubit.dart';
import 'package:provider/provider.dart';
import '../viewModel/repository_detail_screen_states.dart';

class RepositoryDetailsPage extends StatelessWidget {
  final GitHubProject? project;
  const RepositoryDetailsPage(this.project, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailScreenCubit()
        ..fetchGitHubProjectBranches(
          context, project?.owner?.login ?? '', project?.name ?? '',
        ),
      child: const _RepositoryDetailsView(),
    );
  }
}

class _RepositoryDetailsView extends StatelessWidget {
  const _RepositoryDetailsView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailScreenCubit, DetailScreenState>(
      builder: (context, state) {
        final cubit = context.read<DetailScreenCubit>();

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(context),
              if (state is DetailScreenLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF706CFF)),
                  ),
                )
              else if (state is DetailScreenError)
                Expanded(
                  child: Center(
                    child: Text(state.errorMessage),
                  ),
                )
              else if (state is DetailScreenLoaded)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          buildBranchSelector(cubit),
                          const SizedBox(height: 10),
                          if (cubit.displayedCommits?.commitsLists == null)
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'No commits available',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: ListView.builder(
                                itemCount: cubit.displayedCommits?.commitsLists.length ?? 0,
                                itemBuilder: (context, index) => buildCommitCard(cubit, index),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context) {
    final project = context.findAncestorWidgetOfExactType<RepositoryDetailsPage>()?.project;

    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(color: Color(0xFF706CFF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              ),
              const Spacer(),
              const Text(
                'Project',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  project?.owner?.avatarUrl ??
                      'https://cyclr.com/wp-content/uploads/2022/03/ext-495.png',
                ),
                radius: 20,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project?.name ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    project?.owner?.login ?? '',
                    style: const TextStyle(fontSize: 14, color: Color(0xFFE1E2FF)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Last update : ${project?.updatedAt ?? ''}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget buildBranchSelector(DetailScreenCubit cubit) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cubit.branches.length,
        itemBuilder: (context, index) {
          final isSelected = cubit.selectedIndex == index;
          return GestureDetector(
            onTap: () => cubit.filterCommits(cubit.branches[index]!, index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF27274A) : const Color(0xFFF3F4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                cubit.branches[index]!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF5F607E),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCommitCard(DetailScreenCubit cubit, int index) {
    final commit = cubit.displayedCommits?.commitsLists[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF6F5FE)),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFF6F6F6),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5EB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.folder, color: Color(0xFFFDBD00)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commit?.commit?.message ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF27274A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  commit?.commit?.committer?.date ?? '',
                  style: const TextStyle(color: Color(0xFF5F607E)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      commit?.commit?.author?.name ?? '',
                      style: const TextStyle(color: Color(0xFF5F607E)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}