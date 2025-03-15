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
