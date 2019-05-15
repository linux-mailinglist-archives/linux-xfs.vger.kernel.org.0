Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72161E88E
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 08:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbfEOGu7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 02:50:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55730 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfEOGu7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4YQoEq+xYzb+s3Q4v2cRj8SPb/5KvEKCN1XKFgZyVxc=; b=Sjt4eQWq0WyolfH85x6Ogk33X
        m/JoBLQrNlyU9ihHx7MR/6g5V5kKM0Iyj1DSZqLmk1tLkfPh9RR/yfORlC35lMLlNGzVgCPN283Hk
        MrJTb9K0TgJm4Z6a2txrThdXvAunKql7c9WI5/abHHzdoHCkFEHKOA5BsJmXmw8HsUQP4W04M6b8N
        ZKX1gxmueQ7VmdDGyQ/A7YSKxL5Ceuz3rDX/6+xLJCnJONAak21cxAfalkbfTBw7m/Ad0QQrwUVfN
        m5NQ75zK0d6pMDfVCmwxY+G+PORrCaf5SG5ZyaZ2Pf/9jqOA3v1bpjja2nyLWoUA8VnrPH2Dn+T0H
        mxGEh0jQQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQnkh-0000PO-Fc; Wed, 15 May 2019 06:50:59 +0000
Date:   Tue, 14 May 2019 23:50:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/11] libxfs: remove xfs_inode_log_item ili_flags
Message-ID: <20190515065059.GB29211@infradead.org>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557519510-10602-3-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 10, 2019 at 03:18:21PM -0500, Eric Sandeen wrote:
> ili_flags is only set to zero and asserted to be zero; it serves
> no purpose, so remove it.
> 
> (it was renamed to ili_lock_flags in the kernel in commit 898621d5,
> for some reason userspace had both, with ili_flags ~unused)

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
