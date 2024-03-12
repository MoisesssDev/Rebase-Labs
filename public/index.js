function fetchData(callback) {
    var apiUrl = '/api/v1/tests';
  
    fetch(apiUrl)
      .then(response => {
        if (!response.ok) {
          throw new Error('Erro na requisição: ' + response.statusText);
        }
        return response.json();
      })
      .then(data => callback(data))
      .catch(error => {
        console.error('Erro:', error);
      });
  }
  
  function generateTableBody(data) {
    // Função para gerar o corpo da tabela com base nos dados fornecidos
    return data.map(item => `
      <tr>
        <td>${item.cpf}</td>
        <td>${item.name}</td>
        <td>${item.email}</td>
        <td>${item.birthday}</td>
        <td>${item.doctor.crm}</td>
        <td>${item.doctor.crm_state}</td>
        <td>${item.doctor.name}</td>
        <td>${item.result_token}</td>
        <td>${item.result_date}</td>
        <td><a href="/${item.result_token}">Detalhes</a></td>
      </tr>
    `).join('');
  }
  
  function renderTable(data) {
    // Função para renderizar a tabela no DOM
    if (!data) {
      document.getElementById('table-container').innerHTML = '<p>Não existe resultados de exames.</p>';
      return;
    }
  
    var title = '<h2><img src="images/note.png" alt="exames"> Resultado dos exames</h2>';
    var search = '<input type="text" id="search" placeholder="Pesquisar...">';
    var msgWelcome = '<p>&#128075; Bem-vindo ao Rebase Labs! Consulte abaixo os resultados dos exames.</p>';
    var navTable = `<div class="nav-table">${msgWelcome}<div class="nav-table-content">${title}${search}</div></div>`;
  
    var tableHeader = `
      <thead>
        <tr>
          <th>CPF</th>
          <th>Nome</th>
          <th>Email</th>
          <th>Data de Nascimento</th>
          <th>CRM do Médico</th>
          <th>Estado do CRM</th>
          <th>Nome do Médico</th>
          <th>Token do Resultado</th>
          <th>Data do Exame</th>
          <th>Exames</th>
        </tr>
      </thead>
    `;
  
    var tableBody = `<tbody>${generateTableBody(data)}</tbody>`;
    var table = `${navTable}<table>${tableHeader}${tableBody}</table>`;
  
    // Adicionar o ouvinte de eventos ao input de pesquisa
    var tableContainer = document.getElementById('table-container');
    tableContainer.innerHTML = table;
  
    var searchInput = document.getElementById('search');
    searchInput.addEventListener('input', function () {
      filterTable(searchInput.value);
    });
  }
  
  function filterTable(filterText) {
    // Função para filtrar os resultados da tabela com base no texto fornecido
    var tabelaExames = document.querySelector('table');
    var linhas = tabelaExames.querySelectorAll('tbody tr');
  
    linhas.forEach(function (linha) {
      var textoLinha = linha.innerText.toLowerCase();
      var filtroLowerCase = filterText.toLowerCase();
      linha.style.display = textoLinha.includes(filtroLowerCase) ? '' : 'none';
    });
  }
  
  function showDetails() {
    console.log('Implemente a lógica para exibir detalhes dos exames aqui.');
  }
  
  document.addEventListener('DOMContentLoaded', function () {
    fetchData(function (data) {
      console.log(data);
      renderTable(data);
    });
  });
  