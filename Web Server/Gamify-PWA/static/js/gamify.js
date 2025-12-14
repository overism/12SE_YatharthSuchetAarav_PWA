function showPopup(title, message, onClose = null) {
    const popup = document.createElement("div");
    popup.className = "popup";

    popup.innerHTML = `
        <div class="popup-box">
            <h2>${title}</h2>
            <p>${message}</p>
            <button id="popup-close">OK</button>
        </div>
    `;

    document.body.appendChild(popup);

    document.getElementById("popup-close").onclick = () => {
        popup.remove();
        if (typeof onClose === "function") {
            onClose();
        }
    };
}

const loginForm = document.getElementById('loginForm');
if (loginForm) {
    loginForm.addEventListener('submit', function(event) {
        event.preventDefault();

        fetch('/login_validation', {
            method: 'POST',
            body: new FormData(this)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showPopup("Login Successful", data.message, () => {
                    window.location.href = "/home";
                });
            } else {
                showPopup("Login Failed", data.message);
            }
        })
        .catch(() => {
            showPopup("Error", "Unable to login. Please try again.");
        });
    });
}

const signupForm = document.getElementById('signupForm');
if (signupForm) {
    signupForm.addEventListener('submit', function(e) {
        e.preventDefault();

        if (!this.checkValidity()) {
            this.reportValidity();
            return;
        }

        const pw = document.getElementById('password').value;
        const cpw = document.getElementById('confirmPassword').value;

        if (pw !== cpw) {
            showPopup("Signup Error", "Passwords do not match.");
            return;
        }

        fetch("/add_user", {
            method: "POST",
            body: new FormData(this)
        })
        .then(res => res.json())
        .then(data => {
            showPopup(data.title, data.message, () => {
                if (data.success) {
                    window.location.href = "/login";
                }
            });
        })
        .catch(() => {
            showPopup("Server Error", "Something went wrong. Please try again later.");
        });
    });
}

document.querySelectorAll('.game-card').forEach(card => {
  card.addEventListener('click', () => {
    const banner = card.dataset.banner;
    const link = card.dataset.link;
    const overlay = document.getElementById('overlay');

    overlay.style.backgroundImage = `url(${banner})`;
    overlay.classList.add('active');

    setTimeout(() => {
      window.location.href = link;
    }, 600);
  });
});

document.getElementById('saveBio').addEventListener('click', (e) => {
  e.preventDefault();
  saveBio();
});

async function saveBio() {
  const bio = document.getElementById('bioEditor').value;
  const bioStatus = document.getElementById('bioStatus');
  bioStatus.textContent = 'Saving...';

  try {
    const response = await fetch('/save-bio', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ bio: bio })
    });

    if (response.ok) {
      bioStatus.textContent = 'Saved';
      setTimeout(() => bioStatus.textContent = '', 2000);
    } else {
      bioStatus.textContent = 'Error saving bio';
    }
  } catch (error) {
    bioStatus.textContent = 'Error saving bio';
  }
}

document.getElementById('resetBio').addEventListener('click', (e) => {
  e.preventDefault();
  document.getElementById('bioEditor').value = '{{ user.userBio }}';
  document.getElementById('bioStatus').textContent = 'Reset';
  setTimeout(() => document.getElementById('bioStatus').textContent = '', 1400);
});

// Handle Avatar Upload
document.getElementById('avatarForm').addEventListener('submit', (e) => {
  e.preventDefault();

  const formData = new FormData(e.target);
  fetch('/upload-avatar', {
    method: 'POST',
    body: formData
  })
  .then(response => response.json())
  .then(data => {
    if (data.status === 'success') {
      // Update avatar image after successful upload
      const avatar = document.getElementById('profileAvatar');
      avatar.src = data.filepath;  // New file path returned by backend
    }
  });
});
