Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD6C1A3064
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Apr 2020 09:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgDIHof (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Apr 2020 03:44:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52590 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgDIHof (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 03:44:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=eWa6K0PFqt5d8byLJ3eTUVQOEK
        jP05BTWOZVgeRQzPQ85v2NvesHBGCtze68Hd8ay+LBYxn14Ig1SMb+XVyiKsHfPdmHzriD3oC1Mxc
        oom0SJA//7c9loaoeO6ZHct8CYZRB13kihmbgatiUX7tT5D2czz1AIP2oYzbtpv64UkWGX00z8yhw
        aBWFR+p3Wwd5GnavPOpFACPd4BBY8CSF9Qp+r9KMUZ9FNOexycj3snsvXGHL8bZyH+Nm+QmSxXBh/
        PJEdZk3WtyGj6ACQTHgSKoPhQs4HF/voXwj1fUKJRkaT3NB7aOHm1nzz4g/I+Z+9KUnxEYoj60cSZ
        idAaHQiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMRrW-0000dM-3H; Thu, 09 Apr 2020 07:44:34 +0000
Date:   Thu, 9 Apr 2020 00:44:34 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_scrub: fix type error in render_ino_from_handle
Message-ID: <20200409074434.GH21033@infradead.org>
References: <158619914362.469742.7048317858423621957.stgit@magnolia>
 <158619917550.469742.14501955862263559558.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158619917550.469742.14501955862263559558.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
