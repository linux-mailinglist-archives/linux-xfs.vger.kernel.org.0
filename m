Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1328A3565DE
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Apr 2021 09:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbhDGH7Q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Apr 2021 03:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235082AbhDGH7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Apr 2021 03:59:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9343FC06174A
        for <linux-xfs@vger.kernel.org>; Wed,  7 Apr 2021 00:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=uS29HIZMAFSbpP0owF/i/71ZAt
        Zlz3rRn4NXVnjsmdygDbT0comj9wSMbeDEYSoUrHRADs7ryZFIYV13r5doAtvN7OjpO5f9cFPygEs
        APHKJRHOll0u/A3c7+BLW7aGb8u3eYicMxECcA2egeXlddeW0xQLXv/VOxydzkSTxr3JYrfvVMSaD
        n3QhPhQi2Hh4dYTehCIenERNaw7eG0HymNLqjbpAw/2eKZ2LDuRlWi1cEp6r4fPaRe2Pv34pnDWH+
        7432gBOALXfOzzjMH2grZKWzyrnmxHIu0UrFs9v86kleoy0V/si0PBfsNEXARm5PSNhB9ISNLv9u/
        hGDzrz6A==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lU35U-00E7fB-Ir; Wed, 07 Apr 2021 07:58:58 +0000
Date:   Wed, 7 Apr 2021 08:58:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] xfs: skip dquot reservations if quota is inactive
Message-ID: <20210407075856.GA3363884@infradead.org>
References: <20210406144238.814558-1-bfoster@redhat.com>
 <20210406144238.814558-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406144238.814558-2-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
