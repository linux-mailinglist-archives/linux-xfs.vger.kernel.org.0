Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F18954CAC
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbfFYKtd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:49:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfFYKtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=cltGkpDcG3bPZQdrof1Baq7I5
        W9cngbyNL/3NRyd97iWWcU/7CW/REmjCpyiIKpA99MasdYjhZ9iyklP2ZMEug6bNdDhRZyoq2Auwr
        9oZJOaH87Kyz/IS0u3dVKVJ84YJyDRWbBHV1b+UqEN8T7Cx94VjJd6/m8N65zx+bA26t+ps1Z3gb3
        fg3vkfw+tKz1E/+5PxeohkmVh8Q8PyfxCLYrlstDu9oNXaj2MRoyWAZKyzo01fif0UE1xUAHPeSCa
        e0aU62l884CUyd2HDAGtt8AUk6bnBqhH9RHbb/nODJt64q7xyboCagAt2hzTk/LyBmwgMORqpRh60
        o14dRrrCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfj13-0005LK-AR; Tue, 25 Jun 2019 10:49:33 +0000
Date:   Tue, 25 Jun 2019 03:49:33 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: don't search for libxfs.h in system headers
Message-ID: <20190625104933.GJ30156@infradead.org>
References: <b1265852-70ea-5402-191d-b3843996fc89@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1265852-70ea-5402-191d-b3843996fc89@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
