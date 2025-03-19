import React from 'react';
import styled from 'styled-components';
import { Link } from 'react-router-dom';

const HeaderContainer = styled.header`
  background-color: #1da1f2;
  color: white;
  padding: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

const Logo = styled.h1`
  margin: 0;
  font-size: 1.5rem;
`;

const Nav = styled.nav`
  display: flex;
  gap: 1rem;
`;

const NavLink = styled(Link)`
  color: white;
  text-decoration: none;
  &:hover {
    text-decoration: underline;
  }
`;

const Header: React.FC = () => {
  return (
    <HeaderContainer>
      <Logo>X投稿管理システム</Logo>
      <Nav>
        <NavLink to="/">トップページ</NavLink>
      </Nav>
    </HeaderContainer>
  );
};

export default Header;
