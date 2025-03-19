import React from 'react';
import { Link } from 'react-router-dom';
import styled from 'styled-components';

const Header: React.FC = () => {
  return (
    <HeaderContainer>
      <HeaderContent>
        <Logo to="/">X投稿管理システム</Logo>
        <Nav>
          <NavLink to="/">トップページ</NavLink>
        </Nav>
      </HeaderContent>
    </HeaderContainer>
  );
};

const HeaderContainer = styled.header`
  background-color: #1da1f2;
  color: white;
  padding: 12px 0;
`;

const HeaderContent = styled.div`
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
`;

const Logo = styled(Link)`
  color: white;
  font-size: 20px;
  font-weight: bold;
  text-decoration: none;
`;

const Nav = styled.nav`
  display: flex;
  gap: 20px;
`;

const NavLink = styled(Link)`
  color: white;
  text-decoration: none;
  font-weight: 500;
  
  &:hover {
    text-decoration: underline;
  }
`;

export default Header;
