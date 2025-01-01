let toolsData = [];

async function fetchData() {
    const response = await fetch('toolsData.json');
    toolsData = await response.json();
    populateTable(toolsData);
}

function populateTable(data) {
    const tableBody = document.getElementById('toolsTable');
    tableBody.innerHTML = '';
    data.forEach(tool => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${tool.name}</td>
            <td>${tool.coinAmount}</td>
            <td>${tool.usdAmount}</td>
        `;
        row.onclick = () => openModal(tool);
        tableBody.appendChild(row);
    });
}

function filterTable() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();
    const filteredData = toolsData.filter(tool =>
        tool.name.toLowerCase().includes(searchTerm)
    );
    populateTable(filteredData);
}

function sortTable(field, order) {
    const sortedData = toolsData.slice().sort((a, b) => {
        if (order === 'asc') return a[field] > b[field] ? 1 : -1;
        return a[field] < b[field] ? 1 : -1;
    });
    populateTable(sortedData);
}

function openModal(tool) {
    document.getElementById('toolName').textContent = tool.name;
    document.getElementById('toolDetails').textContent = `Coin Amount: ${tool.coinAmount} | USD Amount: ${tool.usdAmount}`;
    document.getElementById('toolModal').classList.add('active');
}

function closeModal() {
    document.getElementById('toolModal').classList.remove('active');
}

fetchData();