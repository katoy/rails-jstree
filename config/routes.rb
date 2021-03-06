Rails.application.routes.draw do
  root        to: 'tree#index'
  get 'tree', to:  'tree#index'

  get 'fileData',    to: 'tree#fileData'
  get 'imageData',   to: 'tree#imageData'

  get 'treeData',    to: 'tree#treeData'
  get 'treeDataCsv', to: 'tree#treeDataCsv'

  get 'treeselect', to: 'treeselect#index'
end
