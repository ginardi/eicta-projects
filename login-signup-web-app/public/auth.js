

/* -------------------- SIGN-UP -------------------- */
document.getElementById("signup-form").addEventListener("submit", function (event) {
    event.preventDefault(); // Prevent normal form submission
  
    // Read form values
    const email = document.getElementById("signup-email").value;
    const password = document.getElementById("signup-password").value;
    const passwordConfirm = document.getElementById("signup-password-confirm").value;
    const firstName = document.getElementById("signup-first-name").value;
    const lastName = document.getElementById("signup-last-name").value;
    const dateOfBirth = document.getElementById("signup-dob").value;
    const address = document.getElementById("signup-address").value;
  
    // Extra client-side validation: password match
    if (password !== passwordConfirm) {
      alert("Passwords do not match.");
      return;
    }
  
    // Use built-in HTML5 validation
    const form = document.getElementById("signup-form");
    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }
  
    // Data to send to the server
    const user = {
      email: email,
      password: password,
      first_name: firstName,
      last_name: lastName,
      date_of_birth: dateOfBirth,
      address: address
    };
  
    // Send POST request to /api/signup
    fetch("/api/signup", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(user)
    })
      .then(async response => {
        const data = await response.json();
  
        if (!response.ok) {
          // Error during sign-up
          alert(data.message || "Sign-up failed.");
        } else {
          // Successful sign-up
          alert(data.message || "Sign-up successful.");
          form.reset();
        }
      })
      .catch(() => {
        alert("Network error during sign-up.");
      });
  });
  
  
  /* -------------------- LOGIN -------------------- */
  document.getElementById("login-form").addEventListener("submit", function (event) {
    event.preventDefault();
  
    const email = document.getElementById("login-email").value;
    const password = document.getElementById("login-password").value;
  
    const form = document.getElementById("login-form");
    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }
  
    const credentials = { email, password };
  
    // Send POST request to /api/login
    fetch("/api/login", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(credentials)
    })
      .then(async response => {
        const data = await response.json();
  
        if (!response.ok) {
          // Login failed
          alert(data.message || "Login failed.");
        } else {
          // Login successful
          alert(data.message || "Login successful.");
          form.reset();
        }
      })
      .catch(() => {
        alert("Network error during login.");
      });
  });

