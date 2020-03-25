Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B29B192BA8
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Mar 2020 16:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgCYPBN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Mar 2020 11:01:13 -0400
Received: from verein.lst.de ([213.95.11.211]:41195 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbgCYPBM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Mar 2020 11:01:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6EDE168B05; Wed, 25 Mar 2020 16:01:08 +0100 (CET)
Date:   Wed, 25 Mar 2020 16:01:08 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>, linux-xfs@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] fs: avoid double-writing the inode on a lazytime
 expiration
Message-ID: <20200325150108.GA14435@lst.de>
References: <20200325122825.1086872-1-hch@lst.de> <20200325122825.1086872-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325122825.1086872-3-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 25, 2020 at 01:28:23PM +0100, Christoph Hellwig wrote:
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1448,6 +1448,11 @@ static struct dquot **ext4_get_dquots(struct inode *inode)
>  	return EXT4_I(inode)->i_dquot;
>  }
>  
> +static void ext4_lazytime_expired(struct inode *inode)
> +{
> +	return ext4_dirty_inode(inode, I_DIRTY_SYNC);
> +}

FYI: this is inside an #ifdef CONFIG_QUOTA, so I'll have to respin even
if the overall approach looks good.
