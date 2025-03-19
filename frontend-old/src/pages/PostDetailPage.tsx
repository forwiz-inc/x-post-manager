import React, { useEffect, useState } from 'react';
import styled from 'styled-components';
import axios from 'axios';
import { useParams, useNavigate } from 'react-router-dom';

const Container = styled.div`
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
`;

const Section = styled.div`
  border: 1px solid #e1e8ed;
  border-radius: 8px;
  padding: 1.5rem;
  background-color: white;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
`;

const Title = styled.h3`
  color: #1da1f2;
  margin-bottom: 1rem;
`;

const PostHeader = styled.div`
  display: flex;
  align-items: center;
  margin-bottom: 1rem;
`;

const AuthorName = styled.span`
  font-weight: bold;
  margin-right: 0.5rem;
`;

const Username = styled.span`
  color: #657786;
`;

const PostContent = styled.p`
  margin-bottom: 1.5rem;
  white-space: pre-wrap;
`;

const Button = styled.button`
  background-color: #1da1f2;
  color: white;
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 20px;
  font-weight: bold;
  cursor: pointer;
  margin-right: 1rem;
  &:hover {
    background-color: #1a91da;
  }
  &:disabled {
    background-color: #9ad2f6;
    cursor: not-allowed;
  }
`;

const TextArea = styled.textarea`
  width: 100%;
  min-height: 200px;
  padding: 1rem;
  border: 1px solid #e1e8ed;
  border-radius: 8px;
  margin-bottom: 1.5rem;
  font-family: inherit;
  font-size: inherit;
  resize: vertical;
`;

const ErrorMessage = styled.p`
  color: red;
  margin-top: 1rem;
`;

const SuccessMessage = styled.p`
  color: green;
  margin-top: 1rem;
`;

interface Post {
  id: number;
  x_post_id: string;
  content: string;
  author_username: string;
  author_name: string;
  likes_count: number;
  posted_at: string;
}

const API_BASE_URL = 'http://localhost:3000/api/v1';

const PostDetailPage: React.FC = ()  => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [post, setPost] = useState<Post | null>(null);
  const [transformedContent, setTransformedContent] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const [posting, setPosting] = useState(false);

  useEffect(() => {
    const fetchPost = async () => {
      try {
        const response = await axios.get(`${API_BASE_URL}/posts/${id}`);
        setPost(response.data);
        setLoading(false);
      } catch (err) {
        setError('ポストの取得に失敗しました');
        setLoading(false);
        console.error(err);
      }
    };

    fetchPost();
  }, [id]);

  const handleTransform = async () => {
    try {
      setError(null);
      const response = await axios.get(`${API_BASE_URL}/posts/${id}/transform`);
      setTransformedContent(response.data.transformed_content);
    } catch (err) {
      setError('テキスト変換に失敗しました');
      console.error(err);
    }
  };

  const handlePostToX = async () => {
    if (!transformedContent.trim()) {
      setError('投稿するテキストを入力してください');
      return;
    }

    try {
      setError(null);
      setSuccess(null);
      setPosting(true);
      
      const response = await axios.post(`${API_BASE_URL}/posts/${id}/post_to_x`, {
        content: transformedContent
      });
      
      setSuccess('Xに投稿しました！');
      setPosting(false);
      
      // 3秒後にトップページに戻る
      setTimeout(() => {
        navigate('/');
      }, 3000);
    } catch (err) {
      setError('Xへの投稿に失敗しました');
      setPosting(false);
      console.error(err);
    }
  };

  if (loading) return <Container><p>読み込み中...</p></Container>;
  if (error && !post) return <Container><p>エラー: {error}</p></Container>;
  if (!post) return <Container><p>ポストが見つかりません</p></Container>;

  return (
    <Container>
      <Section>
        <Title>元のポスト</Title>
        <PostHeader>
          <AuthorName>{post.author_name}</AuthorName>
          <Username>@{post.author_username}</Username>
        </PostHeader>
        <PostContent>{post.content}</PostContent>
        <Button onClick={handleTransform}>変換する</Button>
      </Section>
      
      <Section>
        <Title>変換後のテキスト</Title>
        <TextArea
          value={transformedContent}
          onChange={(e) => setTransformedContent(e.target.value)}
          placeholder="「変換する」ボタンをクリックすると、AIが専門的な内容に変換します。"
        />
        <Button onClick={handlePostToX} disabled={posting || !transformedContent.trim()}>
          {posting ? '投稿中...' : 'Xに投稿する'}
        </Button>
        {error && <ErrorMessage>{error}</ErrorMessage>}
        {success && <SuccessMessage>{success}</SuccessMessage>}
      </Section>
    </Container>
  );
};

export default PostDetailPage;
