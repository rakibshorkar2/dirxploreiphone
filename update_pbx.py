import re

project_path = 'ios/Runner.xcodeproj/project.pbxproj'
with open(project_path, 'r', encoding='utf-8') as f:
    content = f.read()

ids = {
    'BackgroundDownloadManager.swift': ('BC000001', 'BC000002'),
    'DownloadTask.swift': ('BC000003', 'BC000004'),
    'ResumeDataManager.swift': ('BC000005', 'BC000006'),
    'KeychainManager.swift': ('BC000007', 'BC000008')
}

# 1. Add to PBXBuildFile section
build_file_section = '/* Begin PBXBuildFile section */'
new_build_files = ''
for f, (ref_id, build_id) in ids.items():
    new_build_files += f'\t\t{build_id} /* {f} in Sources */ = {{isa = PBXBuildFile; fileRef = {ref_id} /* {f} */; }};\n'
content = content.replace(build_file_section, build_file_section + '\n' + new_build_files)

# 2. Add to PBXFileReference section
file_ref_section = '/* Begin PBXFileReference section */'
new_file_refs = ''
for f, (ref_id, build_id) in ids.items():
    new_file_refs += f'\t\t{ref_id} /* {f} */ = {{isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.swift; path = {f}; sourceTree = "<group>"; }};\n'
content = content.replace(file_ref_section, file_ref_section + '\n' + new_file_refs)

# 3. Add to PBXGroup section (Runner group)
group_insertion = ''
for f, (ref_id, build_id) in ids.items():
    group_insertion += f'\t\t\t\t{ref_id} /* {f} */,\n'
pattern = r'(97C146F01CF9000F007C117D /\* Runner \*/ = \{[^{]*children = \(\n)'
content = re.sub(pattern, r'\1' + group_insertion, content)

# 4. Add to PBXSourcesBuildPhase section (Runner target)
sources_section = '97C146EA1CF9000F007C117D /* Sources */ = {\n\t\t\tisa = PBXSourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n'
sources_insertion = ''
for f, (ref_id, build_id) in ids.items():
    sources_insertion += f'\t\t\t\t{build_id} /* {f} in Sources */,\n'
content = content.replace(sources_section, sources_section + sources_insertion)

with open(project_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("PBX Project updated successfully!")
