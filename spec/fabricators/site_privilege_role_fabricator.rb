Fabricator(:site_privilege_role) do
  site_privilege!
  role { SitePrivilegeRole::ROLES.sample }
end
