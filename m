Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52AB35ED1C
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Apr 2021 08:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349191AbhDNGSO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Apr 2021 02:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349187AbhDNGSM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Apr 2021 02:18:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A866C061574;
        Tue, 13 Apr 2021 23:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=C6nYmOVKa3dApGL5LNxPHYTXV/
        3rrDgHmFcyCOzAzYgWd1Eby3kZ2mqX+zFKHGpmmhQ9Dm7MGi8ElkSHn9rjrxl9P6muieEVii5a1vf
        DYFMIWa/R4t23XskLl4LC8HqanCADS14VkcFW6Ujn7QjBr/SkDqFL8ITF7GjBnEkTrG7esQ0lKUJG
        YCQvk8ZJqpDQSrOlChgJk2z50/y3P86WdXOQsQ5ouNHSfuWbVhJ2tE3rMw53hH4PkN6/FRRvmcWVr
        miQ8HAuhF5iwxxvaW7GqbJdYzLLIynTZBttSNfHP1TsYYJj/oMTQE292HBPh3UL6WBNeXQGWvWBww
        7kY7fJ9w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWYqG-006jUw-Dm; Wed, 14 Apr 2021 06:17:45 +0000
Date:   Wed, 14 Apr 2021 07:17:36 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 5/9] common/dmthin: make this work with external log
 devices
Message-ID: <20210414061736.GG1602505@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836230182.2754991.16864806174255630147.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836230182.2754991.16864806174255630147.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
