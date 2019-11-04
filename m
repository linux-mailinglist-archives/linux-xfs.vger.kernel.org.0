Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED0DEE348
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Nov 2019 16:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfKDPOc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 10:14:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57908 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfKDPOc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 10:14:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=p1F3OHg4cEJ9bPDgaPLzM0XP2
        0GN2gPG/6U84Q5EI1xBvaKcbirvfaZ9ZmXR9rJ+hvmJGVhZ7QYVTW14zDggAgG2c3dhvpwhPR7JgM
        kRH3SZizMbj8XN8uo/u11UAAe9ewuJK+L5/yMDBZU2y3rwXmbBhFQuMirXfUzYmWAofN3QvCr1dUI
        fsAcb18bgohMYWQ96sILmL5PYyEC2Hx5IsktmLjumEUcUU+X9nC3UBljYm24vyXU3BWYSvcr6R0sH
        5GxkLr8GBkrhAdtL13dz14xIrrE1kdmZjWly346EjxNeNQc8hzaitx9WLdW5+EmHRh38kNz4aSytt
        SEafjGDHA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRe3r-0003CD-Ch; Mon, 04 Nov 2019 15:14:31 +0000
Date:   Mon, 4 Nov 2019 07:14:31 -0800
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
Subject: Re: [PATCH v9 13/17] xfs: switch to use the new mount-api
Message-ID: <20191104151431.GA10485@infradead.org>
References: <157286480109.18393.6285224459642752559.stgit@fedora-28>
 <157286494412.18393.789343157630779200.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157286494412.18393.789343157630779200.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
