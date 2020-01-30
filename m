Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AFC14E34E
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Jan 2020 20:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgA3Tix (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Jan 2020 14:38:53 -0500
Received: from sandeen.net ([63.231.237.45]:60078 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbgA3Tix (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Jan 2020 14:38:53 -0500
Received: from Liberator.local (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C78CC11665;
        Thu, 30 Jan 2020 13:38:52 -0600 (CST)
Subject: Re: [PATCH 2/6] xfs_repair: enforce that inode btree chunks can't
 point to AG headers
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
 <157982505923.2765631.10587375380960098225.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <eb2b3973-0301-5b96-58e9-7f754a58d0f6@sandeen.net>
Date:   Thu, 30 Jan 2020 13:38:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <157982505923.2765631.10587375380960098225.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/23/20 6:17 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_repair has a very old check that evidently excuses the AG 0 inode
> btrees pointing to blocks that are already marked XR_E_INUSE_FS* (e.g.
> AG headers).  mkfs never formats filesystems that way and it looks like
> an error, so purge the check.  After this, we always complain if inodes
> overlap with AG headers because that should never happen.

I peered back into the mists of time to see if I could find any reason for
this exception, and I couldn't.

Only question is why you removed the

-	ASSERT(M_IGEO(mp)->ialloc_blks > 0);

assert, that's still a valid assert, no?


> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/globals.c    |    1 -
>  repair/globals.h    |    1 -
>  repair/scan.c       |   19 -------------------
>  repair/xfs_repair.c |    7 -------
>  4 files changed, 28 deletions(-)
> 
> 
> diff --git a/repair/globals.c b/repair/globals.c
> index dcd79ea4..8a60e706 100644
> --- a/repair/globals.c
> +++ b/repair/globals.c
> @@ -73,7 +73,6 @@ int	lost_gquotino;
>  int	lost_pquotino;
>  
>  xfs_agino_t	first_prealloc_ino;
> -xfs_agino_t	last_prealloc_ino;
>  xfs_agblock_t	bnobt_root;
>  xfs_agblock_t	bcntbt_root;
>  xfs_agblock_t	inobt_root;
> diff --git a/repair/globals.h b/repair/globals.h
> index 008bdd90..2ed5c894 100644
> --- a/repair/globals.h
> +++ b/repair/globals.h
> @@ -114,7 +114,6 @@ extern int		lost_gquotino;
>  extern int		lost_pquotino;
>  
>  extern xfs_agino_t	first_prealloc_ino;
> -extern xfs_agino_t	last_prealloc_ino;
>  extern xfs_agblock_t	bnobt_root;
>  extern xfs_agblock_t	bcntbt_root;
>  extern xfs_agblock_t	inobt_root;
> diff --git a/repair/scan.c b/repair/scan.c
> index c383f3aa..05707dd2 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -1645,13 +1645,6 @@ scan_single_ino_chunk(
>  				break;
>  			case XR_E_INUSE_FS:
>  			case XR_E_INUSE_FS1:
> -				if (agno == 0 &&
> -				    ino + j >= first_prealloc_ino &&
> -				    ino + j < last_prealloc_ino) {
> -					set_bmap(agno, agbno, XR_E_INO);
> -					break;
> -				}
> -				/* fall through */
>  			default:
>  				/* XXX - maybe should mark block a duplicate */
>  				do_warn(
> @@ -1782,18 +1775,6 @@ _("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\
>  				break;
>  			case XR_E_INUSE_FS:
>  			case XR_E_INUSE_FS1:
> -				if (agno == 0 &&
> -				    ino + j >= first_prealloc_ino &&
> -				    ino + j < last_prealloc_ino) {
> -					do_warn(
> -_("inode chunk claims untracked block, finobt block - agno %d, bno %d, inopb %d\n"),
> -						agno, agbno, mp->m_sb.sb_inopblock);
> -
> -					set_bmap(agno, agbno, XR_E_INO);
> -					suspect++;
> -					break;
> -				}
> -				/* fall through */
>  			default:
>  				do_warn(
>  _("inode chunk claims used block, finobt block - agno %d, bno %d, inopb %d\n"),
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9295673d..3e9059f3 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -460,13 +460,6 @@ calc_mkfs(xfs_mount_t *mp)
>  		first_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno);
>  	}
>  
> -	ASSERT(M_IGEO(mp)->ialloc_blks > 0);
> -
> -	if (M_IGEO(mp)->ialloc_blks > 1)
> -		last_prealloc_ino = first_prealloc_ino + XFS_INODES_PER_CHUNK;
> -	else
> -		last_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno + 1);
> -
>  	/*
>  	 * now the first 3 inodes in the system
>  	 */
> 
