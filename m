Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B7C24A7E
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 10:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfEUIe7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 04:34:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55946 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbfEUIe6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 04:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MMye68bkFHUXNoLg9DDvjrKLCdyczIXrKQW7UiWovG8=; b=NKC1S8d+ZSaiUkjMnMg88fAOi
        5eiRTzIZWXRHnLRc4T941PITGZr0R7jptyjejoKtbYB4q5GpX6rj8S/t3uU9hvju6kdFtfQRqcsbp
        hsM4u4IjOSJwA8od7WOiCyG7bXJCFTS9RKBYxphguEulCfWMzJRFcas7OYSfnQtaDD7lN2ty2wXpO
        dHFd2wLfzsIJClTglRnJebB0aDGjKRpoE+8XqCUeO+RUc+58AwBLVAphfdLrHQxyRcliu6E8Jmt6J
        V4rdnGMP1nit8G13goFyXyH55+1ixLbx/ykuigGThngE2n++Kbb1I9qtpt+pqiNdudWTNEPPGwOUu
        IICvtJDBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hT0Ec-0001Ot-Gj; Tue, 21 May 2019 08:34:58 +0000
Date:   Tue, 21 May 2019 01:34:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] libxfs: fix argument to xfs_trans_add_item
Message-ID: <20190521083458.GD533@infradead.org>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
 <1558410427-1837-5-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558410427-1837-5-git-send-email-sandeen@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 10:47:04PM -0500, Eric Sandeen wrote:
> The hack of casting an inode_log_item or buf_log_item to a
> xfs_log_item_t is pretty gross; yes it's the first member in the
> structure, but yuk.  Pass in the correct structure member.
> 
> This was fixed in the kernel with commit e98c414f9
> ("xfs: simplify log item descriptor tracking")
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
