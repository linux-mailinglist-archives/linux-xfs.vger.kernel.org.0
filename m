Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3762521607
	for <lists+linux-xfs@lfdr.de>; Tue, 10 May 2022 14:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbiEJM6W (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 08:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242084AbiEJM6T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 08:58:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CE32B1DF4
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 05:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=KKIcN9UnX7VIPkQ1dL53hU/53E
        rAMcCkH/DoQNPMXmukKYrjuVIAWDbHmKLqjA4O4wF4FBJMUmEKHntXlg2I14SFnxxN9CeZuMYyhbg
        eCgpiy2fxy7V8QmQKq/Pnk5mrTy+8DWBgbsBACDY1tUqY89gHgtQjoEGfl+66+GzNlLSvjfuRUAGs
        LWVhiFnHZD38/j5+9kHBkmCXjzQEy3G5MX6rRTPa0ebPt6Z5vYdaUiHzX/yK/Vm/oQQ40PHwH7osM
        hk2W382WpSHAiV1tLLIlt4WFi6jWhQDgOzGqmONq9TO8z4jb6Su4nJl1VdDghqgtN9KSrxLGqhXtC
        Z3pbFcUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noPNa-0022H3-H3; Tue, 10 May 2022 12:54:18 +0000
Date:   Tue, 10 May 2022 05:54:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: check the rt summary against observations
Message-ID: <YnpgevAi033kPfFJ@infradead.org>
References: <165176668306.247207.13169734586973190904.stgit@magnolia>
 <165176670555.247207.10826098571443771712.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176670555.247207.10826098571443771712.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
