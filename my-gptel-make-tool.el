(gptel-make-tool
 :name "rename_file"
 :function (lambda (old-name new-name)
             (if (file-exists-p old-name)
                 (rename-file old-name new-name)
               (error "Error: file %s does not exist" old-name))
             (format "Renamed %s to %s" old-name new-name))
 :description "rename a file on disk"
 :args (list '(:name "old-name"
               :type string
               :description "the current name of the file to be renamed")
             '(:name "new-name"
               :type string
               :description "the new name for the file"))
 :category "file")

(gptel-make-tool
 :name "make_directory"
 :function (lambda (directory-path &optional parents)
             (if parents
                 (make-directory directory-path t)
               (make-directory directory-path))
             (format "Created directory: %s" directory-path))
 :description "create a directory on disk"
 :args (list '(:name "directory-path"
               :type string
               :description "the path of the directory to create")
             '(:name "parents"
               :type boolean
               :description "whether to create parent directories as needed"
               :optional t))
 :category "file")

(gptel-make-tool
 :name "create_file"
 :description "create a new file on disk"
 :args (list '(:name "file-path"
               :type string
               :description "the path of the file to create")
             '(:name "content"
               :type string
               :description "optional initial content to write to the file"
               :optional t))
 :category "file")

(gptel-make-tool
 :name "git_create_branch"
 :function (lambda (branch-name &optional start-point)
             (let ((cmd (if start-point
                           (format "git checkout -b %s %s" branch-name start-point)
                         (format "git checkout -b %s" branch-name))))
               (shell-command cmd)
               (format "Created branch '%s'" branch-name)))
 :description "create a new git branch"
 :args (list '(:name "branch-name"
               :type string
               :description "name of the branch to create")
             '(:name "start-point"
               :type string
               :description "commit or branch to start from"
               :optional t))
 :category "git")

(gptel-make-tool
 :name "git_checkout"
 :function (lambda (branch-name)
             (shell-command (format "git checkout %s" branch-name))
             (format "Checked out branch '%s'" branch-name))
 :description "checkout a git branch"
 :args (list '(:name "branch-name"
               :type string
               :description "name of the branch to checkout"))
 :category "git")

(gptel-make-tool
 :name "git_commit"
 :function (lambda (message &optional all)
             (let ((cmd (if all
                           "git commit -am \"%s\""
                         "git commit -m \"%s\"")))
               (shell-command (format cmd message))
               (format "Committed changes with message: '%s'" message)))
 :description "commit changes to git repository"
 :args (list '(:name "message"
               :type string
               :description "commit message")
             '(:name "all"
               :type boolean
               :description "whether to automatically stage all modified files"
               :optional t))
 :category "git")

(gptel-make-tool
 :name "git_add"
 :function (lambda (file-path)
             (shell-command (format "git add %s" file-path))
             (format "Staged file '%s' for commit" file-path))
 :description "stage a file for commit"
 :args (list '(:name "file-path"
               :type string
               :description "path of the file to stage"))
 :category "git")

(gptel-make-tool
 :name "git_push"
 :function (lambda (&optional remote branch)
             (let ((cmd (cond
                         ((and remote branch) (format "git push %s %s" remote branch))
                         (remote (format "git push %s" remote))
                         (t "git push"))))
               (shell-command cmd)
               (format "Pushed changes to remote repository")))
 :description "push changes to remote repository"
 :args (list '(:name "remote"
               :type string
               :description "name of the remote repository"
               :optional t)
             '(:name "branch"
               :type string
               :description "branch to push to remote"
               :optional t))
 :category "git")

(gptel-make-tool
 :name "git_pull"
 :function (lambda (&optional remote branch)
             (let ((cmd (cond
                         ((and remote branch) (format "git pull %s %s" remote branch))
                         (remote (format "git pull %s" remote))
                         (t "git pull"))))
               (shell-command cmd)
               (format "Pulled changes from remote repository")))
 :description "pull changes from remote repository"
 :args (list '(:name "remote"
               :type string
               :description "name of the remote repository"
               :optional t)
             '(:name "branch"
               :type string
               :description "branch to pull from remote"
               :optional t))
 :category "git")

```elisp
(gptel-make-tool
 :name "git_status"
 :function (lambda ()
             (let ((output (shell-command-to-string "git status")))
               (with-current-buffer (get-buffer-create "*Git Status*")
                 (erase-buffer)
                 (insert output)
                 (display-buffer (current-buffer)))
               "Git status displayed in buffer *Git Status*"))
 :description "show git repository status"
 :args nil
 :category "git")

(gptel-make-tool
 :name "git_log"
 :function (lambda (&optional num-commits)
             (let* ((num (or num-commits "10"))
                    (cmd (format "git log -n %s" num))
                    (output (shell-command-to-string cmd)))
               (with-current-buffer (get-buffer-create "*Git Log*")
                 (erase-buffer)
                 (insert output)
                 (display-buffer (current-buffer)))
               (format "Displayed last %s git commits in buffer *Git Log*" num)))
 :description "show git commit history"
 :args (list '(:name "num-commits"
               :type string
               :description "number of commits to show"
               :optional t))
 :category "git")

(gptel-make-tool
 :name "git_diff"
 :function (lambda (&optional file)
             (let* ((cmd (if file
                            (format "git diff %s" file)
                          "git diff"))
                    (output (shell-command-to-string cmd)))
               (with-current-buffer (get-buffer-create "*Git Diff*")
                 (erase-buffer)
                 (insert output)
                 (diff-mode)
                 (display-buffer (current-buffer)))
               "Git diff displayed in buffer *Git Diff*"))
 :description "show git diff"
 :args (list '(:name "file"
               :type string
               :description "specific file to show diff for"
               :optional t))
 :category "git")

(gptel-make-tool
 :name "git_branch_list"
 :function (lambda ()
             (let ((output (shell-command-to-string "git branch")))
               (with-current-buffer (get-buffer-create "*Git Branches*")
                 (erase-buffer)
                 (insert output)
                 (display-buffer (current-buffer)))
               "Git branches displayed in buffer *Git Branches*"))
 :description "list git branches"
 :args nil
 :category "git")

(gptel-make-tool
 :name "git_clone"
 :function (lambda (repository &optional directory)
             (let ((cmd (if directory
                           (format "git clone %s %s" repository directory)
                         (format "git clone %s" repository))))
               (shell-command cmd)
               (format "Cloned repository %s" repository)))
 :description "clone a git repository"
 :args (list '(:name "repository"
               :type string
               :description "URL of the repository to clone")
             '(:name "directory"
               :type string
               :description "directory to clone into"
               :optional t))
 :category "git")

(gptel-make-tool
 :name "git_reset"
 :function (lambda (mode &optional commit)
             (let ((cmd (if commit
                           (format "git reset --%s %s" mode commit)
                         (format "git reset --%s" mode))))
               (shell-command cmd)
               (format "Reset git repository using mode '%s'" mode)))
 :description "reset git repository state"
 :args (list '(:name "mode"
               :type string
               :description "reset mode (soft, mixed, hard)")
             '(:name "commit"
               :type string
               :description "commit to reset to (defaults to HEAD)"
               :optional t))
 :category "git")

i want you to commit the latest changes to this file

I'll commit the latest changes to the file you're working with. I'll use the available tools to perform a git commit operation.
