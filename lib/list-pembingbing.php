<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Daftar Pembingbing</title>
    <style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body {
        background-color: #f5f5f5;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }

    header {
        background-color: #4a6fdc;
        color: white;
        padding: 20px;
        border-radius: 8px 8px 0 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    header h1 {
        font-size: 24px;
    }

    .search-filter {
        background-color: white;
        padding: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #eee;
    }

    .search-filter input {
        padding: 8px 15px;
        border: 1px solid #ddd;
        border-radius: 4px;
        width: 300px;
    }

    .search-filter select {
        padding: 8px 15px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }

    .action-buttons {
        display: flex;
        gap: 10px;
    }

    .action-buttons button {
        padding: 8px 15px;
        background-color: #4a6fdc;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .action-buttons button:hover {
        background-color: #3a5fcc;
    }

    .delete-btn {
        background-color: #dc4a4a !important;
    }

    .delete-btn:hover {
        background-color: #cc3a3a !important;
    }

    .table-container {
        background-color: white;
        border-radius: 0 0 8px 8px;
        overflow: hidden;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    thead {
        background-color: #f2f2f2;
    }

    th,
    td {
        padding: 12px 15px;
        text-align: left;
        border-bottom: 1px solid #eee;
    }

    tbody tr:hover {
        background-color: #f9f9f9;
    }

    .status {
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: bold;
    }

    .status-aktif {
        background-color: #e6f7e6;
        color: #28a745;
    }

    .status-cuti {
        background-color: #fff3cd;
        color: #ffc107;
    }

    .status-nonaktif {
        background-color: #f8d7da;
        color: #dc3545;
    }

    .pagination {
        display: flex;
        justify-content: center;
        padding: 20px 0;
        gap: 5px;
    }

    .pagination button {
        padding: 8px 12px;
        border: 1px solid #ddd;
        background-color: white;
        cursor: pointer;
    }

    .pagination button.active {
        background-color: #4a6fdc;
        color: white;
        border-color: #4a6fdc;
    }

    .action-col {
        display: flex;
        gap: 5px;
    }

    .action-col button {
        padding: 5px 10px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 12px;
    }

    .edit-btn {
        background-color: #ffc107;
        color: white;
    }

    .view-btn {
        background-color: #17a2b8;
        color: white;
    }

    .remove-btn {
        background-color: #dc3545;
        color: white;
    }

    .modal {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        justify-content: center;
        align-items: center;
    }

    .modal-content {
        background-color: white;
        padding: 20px;
        border-radius: 8px;
        width: 500px;
        max-width: 90%;
    }

    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }

    .close {
        font-size: 24px;
        cursor: pointer;
    }

    .form-group {
        margin-bottom: 15px;
    }

    .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }

    .form-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 20px;
    }

    .form-actions button {
        padding: 8px 15px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .save-btn {
        background-color: #28a745;
        color: white;
    }

    .cancel-btn {
        background-color: #6c757d;
        color: white;
    }
    </style>
</head>

<body>
    <div class="container">
        <header>
            <h1>Dashboard Daftar Pembingbing</h1>
        </header>

        <div class="search-filter">
            <input type="text" placeholder="Cari pembimbing..." id="searchInput">
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <!-- <th><input type="checkbox" id="selectAll"></th> -->
                        <th>NO</th>
                        <th>Username</th>
                        <th>Nama</th>
                        <th>Email</th>
                        <th>Telepon</th>
                    </tr>
                </thead>
                <tbody id="mahasiswaTable">
                    <!-- Data pembimbing akan diisi secara dinamis -->
                </tbody>
            </table>
        </div>

        <!-- <div class="pagination">
<button>&laquo;</button>
<button class="active">1</button>
<button>2</button>
<button>3</button>
<button>&raquo;</button>
</div> -->
    </div>


    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <script>
    let dataMahasiswa = [];
    let filteredData = [];

    $.ajax({
        url: 'get_pembingbing.php',
        type: 'GET',
        dataType: 'json',
        success: function(response) {
            if (response.status === 'success') {
                dataMahasiswa = response.data;
                filteredData = [...dataMahasiswa];
                renderMahasiswaTable();
            } else {
                showAlert('error', response.message);
            }
            // hideLoading();
        },
        error: function(xhr, status, error) {
            console.log(error);
            alert('error', 'Gagal memuat data dari server');
            // hideLoading();
        }
    });

    filteredData = [...dataMahasiswa];
    // renderMahasiswaTable();

    let currentId = filteredData.length + 1;
    let editingId = null;
    let selectedRows = [];

    // DOM Elements
    const mahasiswaTable = document.getElementById('mahasiswaTable');
    const selectAllCheckbox = document.getElementById('selectAll');
    const hapusTerpilihBtn = document.getElementById('hapusTerpilih');
    const tambahMahasiswaBtn = document.getElementById('tambahMahasiswa');
    const searchInput = document.getElementById('searchInput');
    // const filterJurusan = document.getElementById('filterJurusan');
    const filterStatus = document.getElementById('filterStatus');
    const mahasiswaModal = document.getElementById('mahasiswaModal');
    const modalTitle = document.getElementById('modalTitle');
    const closeBtn = document.querySelector('.close');
    const cancelFormBtn = document.getElementById('cancelForm');
    const mahasiswaForm = document.getElementById('mahasiswaForm');

    // Render tabel mahasiswa
    function renderMahasiswaTable() {
        mahasiswaTable.innerHTML = '';

        // Filter data
        let filteredData = [...dataMahasiswa];

        const searchTerm = searchInput.value.toLowerCase();

        if (searchTerm) {
            filteredData = filteredData.filter(m =>
                m.username.toLowerCase().includes(searchTerm) ||
                m.nama.toLowerCase().includes(searchTerm)
            );
        }

        // Render rows
        filteredData.forEach((mahasiswa, index) => {
            const row = document.createElement('tr');

            const isSelected = selectedRows.includes(mahasiswa.id);

            row.innerHTML = `<td>${index + 1}</td>
                    <td>${mahasiswa.username}</td>
                    <td>${mahasiswa.nama}</td>
                    <td>${mahasiswa.email}</td>
                    <td>${mahasiswa.telepon}</td>
                `;

            mahasiswaTable.appendChild(row);
        });

        // Attach event listeners untuk row checkboxes
        document.querySelectorAll('.row-checkbox').forEach(checkbox => {
            checkbox.addEventListener('change', handleRowCheckboxChange);
        });

        // Attach event listeners untuk action buttons
        document.querySelectorAll('.edit-btn').forEach(btn => {
            btn.addEventListener('click', handleEditClick);
        });

        document.querySelectorAll('.remove-btn').forEach(btn => {
            btn.addEventListener('click', handleRemoveClick);
        });

        document.querySelectorAll('.view-btn').forEach(btn => {
            btn.addEventListener('click', handleViewClick);
        });

        updateSelectAllCheckboxState();
    }

    // Handle row checkbox change
    function handleRowCheckboxChange(e) {
        const id = parseInt(e.target.getAttribute('data-id'));

        if (e.target.checked) {
            if (!selectedRows.includes(id)) {
                selectedRows.push(id);
            }
        } else {
            selectedRows = selectedRows.filter(rowId => rowId !== id);
        }

        updateHapusTerpilihButtonState();
        updateSelectAllCheckboxState();
    }

    // Update select all checkbox state
    function updateSelectAllCheckboxState() {
        const checkboxes = document.querySelectorAll('.row-checkbox');
        const checkedCheckboxes = document.querySelectorAll('.row-checkbox:checked');

        if (checkboxes.length === 0) {
            selectAllCheckbox.checked = false;
            selectAllCheckbox.indeterminate = false;
        } else if (checkedCheckboxes.length === 0) {
            selectAllCheckbox.checked = false;
            selectAllCheckbox.indeterminate = false;
        } else if (checkedCheckboxes.length === checkboxes.length) {
            selectAllCheckbox.checked = true;
            selectAllCheckbox.indeterminate = false;
        } else {
            selectAllCheckbox.checked = false;
            selectAllCheckbox.indeterminate = true;
        }
    }

    // Update hapus terpilih button state
    function updateHapusTerpilihButtonState() {
        hapusTerpilihBtn.disabled = selectedRows.length === 0;
    }

    // Handle select all checkbox change
    function handleSelectAllChange(e) {
        const checkboxes = document.querySelectorAll('.row-checkbox');

        checkboxes.forEach(checkbox => {
            checkbox.checked = e.target.checked;

            const id = parseInt(checkbox.getAttribute('data-id'));

            if (e.target.checked) {
                if (!selectedRows.includes(id)) {
                    selectedRows.push(id);
                }
            } else {
                selectedRows = selectedRows.filter(rowId => rowId !== id);
            }
        });

        updateHapusTerpilihButtonState();
    }

    // Handle edit button click
    function handleEditClick(e) {
        const id = parseInt(e.target.getAttribute('data-id'));
        const mahasiswa = dataMahasiswa.find(m => m.id === id);

        if (mahasiswa) {
            editingId = id;
            modalTitle.textContent = 'Edit Mahasiswa';

            document.getElementById('nim').value = mahasiswa.nim;
            document.getElementById('nama').value = mahasiswa.nama;
            document.getElementById('jurusan').value = mahasiswa.jurusan;
            document.getElementById('semester').value = mahasiswa.semester;
            document.getElementById('status').value = mahasiswa.status;
            document.getElementById('ipk').value = mahasiswa.ipk;

            mahasiswaModal.style.display = 'flex';
        }
    }

    // Handle view button click
    function handleViewClick(e) {
        const id = parseInt(e.target.getAttribute('data-id'));
        const mahasiswa = dataMahasiswa.find(m => m.id === id);

        if (mahasiswa) {
            alert(`Detail Mahasiswa:
NIM: ${mahasiswa.nim}
Nama: ${mahasiswa.nama}
Jurusan: ${mahasiswa.jurusan}
Semester: ${mahasiswa.semester}
Status: ${mahasiswa.status}
IPK: ${mahasiswa.ipk}`);
        }
    }

    // Handle remove button click
    function handleRemoveClick(e) {
        const id = parseInt(e.target.getAttribute('data-id'));

        if (confirm('Apakah Anda yakin ingin menghapus mahasiswa ini?')) {
            dataMahasiswa = dataMahasiswa.filter(m => m.id !== id);
            selectedRows = selectedRows.filter(rowId => rowId !== id);
            renderMahasiswaTable();
            updateHapusTerpilihButtonState();
        }
    }

    // Handle tambah mahasiswa button click
    function handleTambahMahasiswaClick() {
        editingId = null;
        modalTitle.textContent = 'Tambah Mahasiswa';
        mahasiswaForm.reset();

        // Set default values
        document.getElementById('status').value = 'Aktif';
        document.getElementById('semester').value = '1';

        mahasiswaModal.style.display = 'flex';
    }

    // Handle hapus terpilih button click
    function handleHapusTerpilihClick() {
        if (selectedRows.length === 0) return;

        if (confirm(`Apakah Anda yakin ingin menghapus ${selectedRows.length} mahasiswa terpilih?`)) {
            dataMahasiswa = dataMahasiswa.filter(m => !selectedRows.includes(m.id));
            selectedRows = [];
            renderMahasiswaTable();
            updateHapusTerpilihButtonState();
        }
    }

    // Close modal
    function closeModal() {
        mahasiswaModal.style.display = 'none';
    }

    // Handle form submit
    function handleFormSubmit(e) {
        e.preventDefault();

        const formData = {
            nim: document.getElementById('nim').value,
            nama: document.getElementById('nama').value,
            jurusan: document.getElementById('jurusan').value,
            semester: parseInt(document.getElementById('semester').value),
            status: document.getElementById('status').value,
            ipk: parseFloat(document.getElementById('ipk').value)
        };

        if (editingId === null) {
            // Tambah mahasiswa baru
            const newMahasiswa = {
                id: currentId++,
                ...formData
            };

            dataMahasiswa.push(newMahasiswa);
        } else {
            // Update mahasiswa yang ada
            const index = dataMahasiswa.findIndex(m => m.id === editingId);

            if (index !== -1) {
                dataMahasiswa[index] = {
                    ...dataMahasiswa[index],
                    ...formData
                };
            }
        }

        closeModal();
        renderMahasiswaTable();
    }

    // Event listeners
    selectAllCheckbox.addEventListener('change', handleSelectAllChange);
    tambahMahasiswaBtn.addEventListener('click', handleTambahMahasiswaClick);
    hapusTerpilihBtn.addEventListener('click', handleHapusTerpilihClick);
    closeBtn.addEventListener('click', closeModal);
    cancelFormBtn.addEventListener('click', closeModal);
    mahasiswaForm.addEventListener('submit', handleFormSubmit);

    // Filter event listeners
    searchInput.addEventListener('input', renderMahasiswaTable);
    filterJurusan.addEventListener('change', renderMahasiswaTable);
    filterStatus.addEventListener('change', renderMahasiswaTable);

    // Initialize
    renderMahasiswaTable();
    </script>

</body>

</html>