USE [master]
GO
/****** Object:  Database [kringloopAfhaling]    Script Date: 2-4-2024 15:40:42 ******/
CREATE DATABASE [kringloopAfhaling]
CONTAINMENT = NONE
ON  PRIMARY
( NAME = N'kringloopAfhaling', FILENAME = N'C:\ProgramData\KringloopKleding\kringloopAfhaling.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
LOG ON
( NAME = N'kringloopAfhaling_log', FILENAME = N'C:\ProgramData\KringloopKleding\kringloopAfhaling_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [kringloopAfhaling] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [kringloopAfhaling].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [kringloopAfhaling] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [kringloopAfhaling] SET ANSI_NULLS OFF
GO
ALTER DATABASE [kringloopAfhaling] SET ANSI_PADDING OFF
GO
ALTER DATABASE [kringloopAfhaling] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [kringloopAfhaling] SET ARITHABORT OFF
GO
ALTER DATABASE [kringloopAfhaling] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [kringloopAfhaling] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [kringloopAfhaling] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [kringloopAfhaling] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [kringloopAfhaling] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [kringloopAfhaling] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [kringloopAfhaling] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [kringloopAfhaling] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [kringloopAfhaling] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [kringloopAfhaling] SET  DISABLE_BROKER
GO
ALTER DATABASE [kringloopAfhaling] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [kringloopAfhaling] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [kringloopAfhaling] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [kringloopAfhaling] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [kringloopAfhaling] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [kringloopAfhaling] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [kringloopAfhaling] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [kringloopAfhaling] SET RECOVERY SIMPLE
GO
ALTER DATABASE [kringloopAfhaling] SET  MULTI_USER
GO
ALTER DATABASE [kringloopAfhaling] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [kringloopAfhaling] SET DB_CHAINING OFF
GO
ALTER DATABASE [kringloopAfhaling] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF )
GO
ALTER DATABASE [kringloopAfhaling] SET TARGET_RECOVERY_TIME = 60 SECONDS
GO
ALTER DATABASE [kringloopAfhaling] SET DELAYED_DURABILITY = DISABLED
GO
ALTER DATABASE [kringloopAfhaling] SET QUERY_STORE = OFF
GO
USE [kringloopAfhaling]
GO
/****** Object:  Table [dbo].[afhaling]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[afhaling](
[id] [int] IDENTITY(1,1) NOT NULL,
[datum] [date] NOT NULL,
[gezinslid_id] [int] NOT NULL,
CONSTRAINT [PK_afhaling] PRIMARY KEY CLUSTERED
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gezin]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gezin](
[id] [int] IDENTITY(1,1) NOT NULL,
[kringloopKaartnummer] [varchar](6) NOT NULL,
[achternaam] [varchar](50) NOT NULL,
[actief] [bit] NOT NULL,
[opmerking] [text] NULL,
[verwijzer] [varchar](30) NOT NULL,
[woonplaats] [varchar](50) NOT NULL,
[created] [date] NOT NULL,
CONSTRAINT [PK_gezin] PRIMARY KEY CLUSTERED
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gezinslid]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gezinslid](
[id] [int] IDENTITY(1,1) NOT NULL,
[voornaam] [varchar](50) NOT NULL,
[geboortejaar] [numeric](4, 0) NOT NULL,
[gezin_id] [int] NOT NULL,
[actief] [bit] NOT NULL,
[opmerking] [text] NULL,
CONSTRAINT [PK_gezinslid] PRIMARY KEY CLUSTERED
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[perMaand]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[perMaand] as
select year(afhaling.datum) as jaar,
MONTH(afhaling.datum) as maand,
woonplaats.woonplaats,
count(distinct woonplaats.gezin_id) as gezinnen,
count(distinct afhaling.id) as aantal
from afhaling,
(select gezinslid.gezin_id,gezinslid.id,gezin.woonplaats from gezinslid
inner join gezin on gezin.id = gezinslid.gezin_id) as woonplaats
where woonplaats.id = afhaling.gezinslid_id
group by year(afhaling.datum),MONTH(afhaling.datum), woonplaats.woonplaats
GO
/****** Object:  View [dbo].[opLeeftijd]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[opLeeftijd] as
select year(afhaling.datum) as jaar,
MONTH(afhaling.datum) as maand,
woonplaats.woonplaats,
year(datum)-geboortejaar as leeftijdsgroep,
count(distinct afhaling.id) as aantal
from afhaling,
(select gezinslid.geboortejaar,gezinslid.id,gezin.woonplaats from gezinslid
inner join gezin on gezin.id = gezinslid.gezin_id) as woonplaats
where woonplaats.id = afhaling.gezinslid_id
group by year(afhaling.datum),MONTH(afhaling.datum), woonplaats.woonplaats, year(datum)-geboortejaar
GO
/****** Object:  View [dbo].[registreren]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[registreren] as
select g.voornaam + ' ' + gezin.achternaam as naam,g.geboortejaar,a.datum as vorige,g.opmerking, g.id, g.gezin_id,g.actief
from gezinslid as g
left join (
select max(datum) as datum,gezinslid_id from afhaling
group by gezinslid_id
) as a on a.gezinslid_id = g.id
join gezin on g.gezin_id = gezin.id



GO
/****** Object:  Table [dbo].[doorverwezen]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[doorverwezen](
[id] [int] IDENTITY(1,1) NOT NULL,
[naar] [varchar](30) NOT NULL,
[datum] [date] NOT NULL,
[gezin_id] [int] NOT NULL,
CONSTRAINT [PK_doorverwezen] PRIMARY KEY CLUSTERED
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[inactief]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[inactief](
[id] [int] IDENTITY(1,1) NOT NULL,
[gezinslid_id] [int] NOT NULL,
[datum] [date] NOT NULL,
[reden] [varchar](30) NOT NULL,
CONSTRAINT [PK_inactief] PRIMARY KEY CLUSTERED
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[redenen]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[redenen](
[id] [int] IDENTITY(1,1) NOT NULL,
[reden] [varchar](30) NOT NULL,
CONSTRAINT [pk_reden] PRIMARY KEY CLUSTERED
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED
(
[reden] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[verwijzers]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[verwijzers](
[id] [int] IDENTITY(1,1) NOT NULL,
[verwijzer] [varchar](30) NOT NULL,
[actief] [bit] NOT NULL,
CONSTRAINT [PK_verwijzers] PRIMARY KEY CLUSTERED
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED
(
[verwijzer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[woonplaatsen]    Script Date: 2-4-2024 15:40:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[woonplaatsen](
[id] [int] IDENTITY(1,1) NOT NULL,
[woonplaats] [varchar](50) NOT NULL,
[gemeente] [varchar](50) NOT NULL,
[provincie] [varchar](50) NOT NULL,
CONSTRAINT [PK_woonplaatsens] PRIMARY KEY CLUSTERED
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED
(
[woonplaats] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_afhaling]    Script Date: 2-4-2024 15:40:43 ******/
CREATE NONCLUSTERED INDEX [IX_afhaling] ON [dbo].[afhaling]
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_gezinslid]    Script Date: 2-4-2024 15:40:43 ******/
CREATE NONCLUSTERED INDEX [IX_gezinslid] ON [dbo].[gezinslid]
(
[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[gezin] ADD  DEFAULT (getdate()) FOR [created]
GO
ALTER TABLE [dbo].[afhaling]  WITH CHECK ADD  CONSTRAINT [FK__afhaling__gezins__4AB81AF0] FOREIGN KEY([gezinslid_id])
REFERENCES [dbo].[gezinslid] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[afhaling] CHECK CONSTRAINT [FK__afhaling__gezins__4AB81AF0]
GO
ALTER TABLE [dbo].[doorverwezen]  WITH CHECK ADD  CONSTRAINT [FK__doorverwez__naar__160F4887] FOREIGN KEY([naar])
REFERENCES [dbo].[verwijzers] ([verwijzer])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[doorverwezen] CHECK CONSTRAINT [FK__doorverwez__naar__160F4887]
GO
ALTER TABLE [dbo].[doorverwezen]  WITH CHECK ADD  CONSTRAINT [FK_doorver_gezin1] FOREIGN KEY([gezin_id])
REFERENCES [dbo].[gezin] ([id])
GO
ALTER TABLE [dbo].[doorverwezen] CHECK CONSTRAINT [FK_doorver_gezin1]
GO
ALTER TABLE [dbo].[gezin]  WITH CHECK ADD  CONSTRAINT [FK__gezin__verwijzer__5812160E] FOREIGN KEY([verwijzer])
REFERENCES [dbo].[verwijzers] ([verwijzer])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[gezin] CHECK CONSTRAINT [FK__gezin__verwijzer__5812160E]
GO
ALTER TABLE [dbo].[gezin]  WITH CHECK ADD  CONSTRAINT [FK__gezin__woonplaat__5535A963] FOREIGN KEY([woonplaats])
REFERENCES [dbo].[woonplaatsen] ([woonplaats])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[gezin] CHECK CONSTRAINT [FK__gezin__woonplaat__5535A963]
GO
ALTER TABLE [dbo].[gezinslid]  WITH CHECK ADD FOREIGN KEY([gezin_id])
REFERENCES [dbo].[gezin] ([id])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[inactief]  WITH CHECK ADD  CONSTRAINT [FK_inactief_gezinslid1] FOREIGN KEY([gezinslid_id])
REFERENCES [dbo].[gezinslid] ([id])
GO
ALTER TABLE [dbo].[inactief] CHECK CONSTRAINT [FK_inactief_gezinslid1]
GO
ALTER TABLE [dbo].[inactief]  WITH CHECK ADD  CONSTRAINT [FK_inactief_reden] FOREIGN KEY([reden])
REFERENCES [dbo].[redenen] ([reden])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[inactief] CHECK CONSTRAINT [FK_inactief_reden]
GO
USE [master]
GO
ALTER DATABASE [kringloopAfhaling] SET  READ_WRITE
GO
use [kringloopAfhaling]
insert into redenen
values('1 jaar inactief')
GO
insert into woonplaatsen
values('Roosendaal','Roosendaal','Noord-Brabant')
GO