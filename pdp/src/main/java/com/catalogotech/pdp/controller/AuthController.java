package com.catalogotech.pdp.controller;

import com.catalogotech.pdp.Repository.UsuarioRepository;
import com.catalogotech.pdp.domain.User.Usuario;
import com.catalogotech.pdp.domain.cargos.Cargos;
import com.catalogotech.pdp.domain.role.Role;
import com.catalogotech.pdp.dto.user.LoginRequestDTO;
import com.catalogotech.pdp.dto.user.RegisterRequestDTO;
import com.catalogotech.pdp.dto.user.ResponseDTO;
import com.catalogotech.pdp.security.TokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UsuarioRepository repository;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;

    @PostMapping("/login")
    public ResponseEntity login(@RequestBody LoginRequestDTO body){
        Usuario user2 = this.repository.findByEmail(body.email()).orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        if(passwordEncoder.matches(body.senha(), user2.getSenha())) {
            String token = this.tokenService.generateToken(user2);
            return ResponseEntity.ok(new ResponseDTO(user2.getNome(), token));
        }
        return ResponseEntity.badRequest().build();
    }


    @PostMapping("/register")
    public ResponseEntity register(@RequestBody RegisterRequestDTO body) {
        Optional<Usuario> user = this.repository.findByEmail(body.email());

        if (user.isEmpty()) {
            // Criando novo usuário
            Usuario newUser = new Usuario();
            newUser.setSenha(passwordEncoder.encode(body.senha()));
            newUser.setEmail(body.email());
            newUser.setNome(body.nome());

            // Se o cargoId for fornecido, associar o cargo
            if (body.cargoId() != null) {
                Cargos cargo = new Cargos();
                cargo.setId(body.cargoId());
                newUser.setCargos(cargo);
            }

            // Associar role ao novo usuário
            if (body.role() != null) {
                newUser.setRole(Role.valueOf(body.role().toUpperCase()));
            }

            this.repository.save(newUser);
            String token = this.tokenService.generateToken(newUser);
            return ResponseEntity.ok(new ResponseDTO(newUser.getNome(), token));
        }
        return ResponseEntity.badRequest().build();
    }
}