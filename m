Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012A5EE34A
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Nov 2019 16:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfKDPOp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 10:14:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57940 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfKDPOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 10:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=du9NLxgmHgciFCjkSoL+75hNg
        fMVb96sKozht/YQDD8C9RRm+zxaluzrgrGdhKMgrfW7BPkg8FzY+ks7DQG5sHN/c7QchDMeXi3YTe
        K/znZebrUBQQ8Xr9i9xfMYe51G1QIH/VVm2KNYvubfh1vEXfNk1DYxcnZRYuD8xIfRv3GlGwc7CPF
        NFRSXiWTpTe/cxuR/Tk66HVlu1kgpIKDNpi3jhAjTGFKJuCUfGNU3Mogv7gmqhTt69y9TbLD1Vn5G
        aAiIu3J8Yq8nlyngPxNL7eoDWOY7O4jhm2EM0xBt/mqxo8vm44fOrE8Z5L7faqKZNQ1hq4W1x9LKk
        Jk68Xf5Qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRe45-0003Ea-3X; Mon, 04 Nov 2019 15:14:45 +0000
Date:   Mon, 4 Nov 2019 07:14:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 17/17] xfs: fold xfs_mount-alloc() into
 xfs_init_fs_context()
Message-ID: <20191104151445.GB10485@infradead.org>
References: <157286480109.18393.6285224459642752559.stgit@fedora-28>
 <157286496581.18393.3802665855647124772.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157286496581.18393.3802665855647124772.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
