<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistem Informasi Mahasiswa</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
    .loading {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.5);
        z-index: 9999;
        justify-content: center;
        align-items: center;
    }

    .loading-spinner {
        width: 3rem;
        height: 3rem;
    }
    </style>
</head>

<body>
    <!-- Loading Indicator -->
    <div class="loading">
        <div class="spinner-border text-light loading-spinner" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>

    <div class="container py-4">
        <h1 class="text-center mb-4">Sistem Informasi Mahasiswa</h1>

        <!-- Filters -->
        <div class="row mb-3">
            <div class="col-md-5 mb-2">
                <select id="filterJurusan" class="form-select">
                    <option value="">Semua Jurusan</option>
                    <option value="Informatika">Informatika</option>
                    <option value="Sistem Informasi">Sistem Informasi</option>
                    <option value="Teknik Komputer">Teknik Komputer</option>
                    <option value="Teknik Elektro">Teknik Elektro</option>
                </select>
            </div>
            <!-- <div class="col-md-3 mb-2">
<select id="filterStatus" class="form-select">
<option value="">Semua Status</option>
<option value="Aktif">Aktif</option>
<option value="Cuti">Cuti</option>
<option value="Nonaktif">Nonaktif</option>
</select>
</div> -->
            <div class="col-md-5 mb-2">
                <input type="text" id="searchInput" class="form-control" placeholder="Cari Nama...">
            </div>
            <div class="col-md-2 mb-2">
                <button id="btnTambahMahasiswa" class="btn btn-primary w-100">
                    <i class="fas fa-plus"></i> Tambah
                </button>
            </div>
        </div>

        <!-- Table -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>No</th>
                        <th>Username</th>
                        <th>Nama</th>
                        <th>Jurusan</th>
                        <th>Role</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody id="tableMahasiswa">
                    <!-- Data will be loaded here -->
                </tbody>
            </table>
        </div>

        <!-- No Data Message -->
        <div id="noData" class="alert alert-info text-center d-none">
            Tidak ada data mahasiswa yang ditemukan.
        </div>
    </div>

    <!-- Form Modal -->
    <div class="modal fade" id="formModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Tambah Mahasiswa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="formMahasiswa">
                        <input type="hidden" id="id" name="id">

                        <div class="mb-3">
                            <label for="nim" class="form-label">NIM</label>
                            <input type="text" class="form-control" id="nim" name="nim" required>
                        </div>

                        <div class="mb-3">
                            <label for="nama" class="form-label">Nama</label>
                            <input type="text" class="form-control" id="nama" name="nama" required>
                        </div>

                        <div class="mb-3">
                            <label for="jurusan" class="form-label">jurusan</label>
                            <input type="text" class="form-control" id="jurusan" name="jurusan" required>
                        </div>

                        <div class="mb-3">
                            <label for="pembimbing" class="form-label">Pembingbing</label>
                            <select class="form-select" id="pembimbing" name="pembimbing" required>
                                <?php
require_once 'koneksi.php';

$conn->set_charset("utf8");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Fetch products from database
$sql = "SELECT id, nama FROM users WHERE role = 'pembimbing' ORDER BY id DESC";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        echo "<option value=\"" . $row["id"] . "\">" . $row["nama"] . "</option>";
    }
} else {
    echo "<option value=\"\">No nama found</option>";
}
$conn->close();
?>
                            </select>
                        </div>

                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="button" class="btn btn-primary" id="btnSimpan">Simpan</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Konfirmasi Hapus</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Apakah Anda yakin ingin menghapus data mahasiswa <strong id="deleteNama"></strong>?</p>
                    <input type="hidden" id="deleteId">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="button" class="btn btn-danger" id="btnKonfirmasiHapus">Hapus</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
    // Global variables
    let dataMahasiswa = [];
    let filteredData = [];
    const formModal = new bootstrap.Modal(document.getElementById('formModal'));
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));

    // Initialization
    $(document).ready(function() {
        // Load data
        loadData();

        // Event listeners
        $('#btnTambahMahasiswa').click(function() {
            resetForm();
            $('#modalTitle').text('Tambah Mahasiswa');
            formModal.show();
        });

        $('#btnSimpan').click(function() {
            if (validateForm()) {
                saveMahasiswa();
            }
        });

        $('#btnKonfirmasiHapus').click(function() {
            const id = $('#deleteId').val();
            if (id) {
                deleteMahasiswa(id);
            }
        });

        // Filters
        $('#filterJurusan').change(function() {
            applyFilters();
        });

        $('#searchInput').on('input', function() {
            applyFilters();
        });
    });

    // Functions
    function loadData() {
        showLoading();

        $.ajax({
            url: 'get_mahasiswa.php',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                if (response.status === 'success') {
                    dataMahasiswa = response.data;
                    filteredData = [...dataMahasiswa];
                    renderTable();
                } else {
                    showAlert('error', response.message);
                }
                hideLoading();
            },
            error: function(xhr, status, error) {
                console.error(error);
                showAlert('error', 'Gagal memuat data dari server');
                hideLoading();
            }
        });


        filteredData = [...dataMahasiswa];
        renderTable();

        setTimeout(hideLoading, 500); // Simulate loading
    }

    function renderTable() {
        const tableBody = $('#tableMahasiswa');
        tableBody.empty();

        if (filteredData.length === 0) {
            $('#noData').removeClass('d-none');
            return;
        }

        $('#noData').addClass('d-none');

        filteredData.forEach((item, index) => {
            // Determine status class
            // let statusClass = 'bg-success';
            // if (item.status === 'Cuti') {
            //     statusClass = 'bg-warning';
            // } else if (item.status === 'Nonaktif') {
            //     statusClass = 'bg-danger';
            // }

            // Determine IPK class
            let roleClass = 'text-primary';
            if (item.role == 'mahasiswa') {
                roleClass = 'text-info';
            } else if (item.role == 'pembingbing') {
                roleClass = 'text-warning';
            }

            tableBody.append(`
                    <tr>
                        <td>${index + 1}</td>
                        <td>${item.username}</td>
                        <td>${item.nama}</td>
                        <td>${item.program_studi}</td>
                        <td class="${roleClass} fw-bold">${item.role}</td>
                        <td>
                            <button class="btn btn-sm btn-info btn-edit" data-id="${item.id}">
                                Set Pembingbing
                            </button>
                        </td>
                    </tr>
                `);
        });

        // Add event listeners to the new buttons
        $('.btn-edit').click(function() {
            const id = $(this).data('id');
            editMahasiswa(id);
        });

        $('.btn-delete').click(function() {
            const id = $(this).data('id');
            const nama = $(this).data('nama');
            showDeleteConfirmation(id, nama);
        });
    }

    function applyFilters() {
        const jurusan = $('#filterJurusan').val();
        // const status = $('#filterStatus').val();
        const search = $('#searchInput').val().toLowerCase();

        filteredData = dataMahasiswa.filter(item => {
            const matchesJurusan = jurusan ? item.jurusan === jurusan : true;
            // const matchesStatus = status ? item.status === status : true;
            const matchesSearch = search ?
                item.nama.toLowerCase().includes(search) ||
                item.nim.toLowerCase().includes(search) : true;

            return matchesJurusan && matchesSearch;
        });

        renderTable();
    }

    function resetForm() {
        $('#formMahasiswa')[0].reset();
        $('#id').val('');
    }

    function validateForm() {
        // Get form and check validity using HTML5 validation
        const form = document.getElementById('formMahasiswa');
        return form.checkValidity();
    }

    function saveMahasiswa() {
        showLoading();

        // Get form data
        const id = $('#id').val();
        const mahasiswa = {
            id: id ? parseInt(id) : getNextId(),
            nim: $('#nim').val(),
            nama: $('#nama').val(),
            jurusan: $('#jurusan').val(),
            pembimbing_id: parseInt($('#pembimbing').val()),
        };


        $.ajax({
            url: 'save_mahasiswa.php',
            type: 'POST',
            data: mahasiswa,
            dataType: 'json',
            success: function(response) {
                if (response.status === 'success') {
                    formModal.hide();
                    showAlert('success', response.message);
                    loadData();
                } else {
                    showAlert('error', response.message);
                }
                hideLoading();
            },
            error: function(xhr, status, error) {
                console.error(error);
                showAlert('error', 'Gagal menyimpan data');
                hideLoading();
            }
        });

        // For demonstration, update the local data directly
        const index = dataMahasiswa.findIndex(item => item.id === mahasiswa.id);

        if (index >= 0) {
            // Update existing
            dataMahasiswa[index] = mahasiswa;
            showAlert('success', 'Data mahasiswa berhasil diperbarui');
        } else {
            // Add new
            dataMahasiswa.push(mahasiswa);
            showAlert('success', 'Data mahasiswa berhasil ditambahkan');
        }

        formModal.hide();
        filteredData = [...dataMahasiswa];
        applyFilters(); // Apply any active filters

        setTimeout(hideLoading, 500); // Simulate loading
    }

    function editMahasiswa(id) {
        const mahasiswa = dataMahasiswa.find(item => item.id === id);

        if (mahasiswa) {
            $('#id').val(mahasiswa.id);
            $('#nim').val(mahasiswa.nim);
            $('#nama').val(mahasiswa.nama);
            $('#jurusan').val(mahasiswa.program_studi);
            $('#pembimbing').val(mahasiswa.pembimbing_id);

            $('#modalTitle').text('Set Pembimbing Lapangan');
            formModal.show();
        }
    }

    function showDeleteConfirmation(id, nama) {
        $('#deleteId').val(id);
        $('#deleteNama').text(nama);
        deleteModal.show();
    }

    function deleteMahasiswa(id) {
        showLoading();

        // In a real application, this would be an AJAX call to your PHP backend
        // For example:
        /*
        $.ajax({
        url: 'delete_mahasiswa.php',
        type: 'POST',
        data: { id: id },
        dataType: 'json',
        success: function(response) {
        if (response.status === 'success') {
        deleteModal.hide();
        showAlert('success', response.message);
        loadData();
        } else {
        showAlert('error', response.message);
        }
        hideLoading();
        },
        error: function(xhr, status, error) {
        console.error(error);
        showAlert('error', 'Gagal menghapus data');
        hideLoading();
        }
        });
        */

        // For demonstration, remove from the local data
        dataMahasiswa = dataMahasiswa.filter(item => item.id !== parseInt(id));
        deleteModal.hide();
        showAlert('success', 'Data mahasiswa berhasil dihapus');

        // Update filtered data and table
        filteredData = [...dataMahasiswa];
        applyFilters(); // Apply any active filters

        setTimeout(hideLoading, 500); // Simulate loading
    }

    function getNextId() {
        // Get highest ID from current data and add 1
        return dataMahasiswa.reduce((max, item) => Math.max(max, item.id), 0) + 1;
    }

    function showAlert(type, message) {
        const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
        const alertHtml = `
                <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            `;

        // Insert alert at top of container
        $('.container').prepend(alertHtml);

        // Auto close after 3 seconds
        setTimeout(() => {
            $('.alert').alert('close');
        }, 3000);
    }

    function showLoading() {
        $('.loading').css('display', 'flex');
    }

    function hideLoading() {
        $('.loading').css('display', 'none');
    }
    </script>
</body>

</html>