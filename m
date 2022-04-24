Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B680050CFE7
	for <lists+linux-xfs@lfdr.de>; Sun, 24 Apr 2022 07:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbiDXFqX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 24 Apr 2022 01:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiDXFqW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:46:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CCD19C741
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=dBULcJ4NgueSWdepVb6xZ+NgKnYQ2jCcmst8tmItW5Q=; b=4NG+9fFz2kC75vKWgzCvnIK9XF
        NPxDZmby/W7o+Hlk4sa0BgJaJCVxRh10Mt7eKHgXHmUYJImVf2pkkulv5n1scJ9VrN+Uzbs0h+pwl
        6QbGTbifIMVIZC1cI2rlZ4vxsG6Ms8xQCNu/pJe0dshfaa7N8kp/9+bQklZXNSHbAY7ag4woNob4s
        EUflbKEj8xZd9stqm9315FuteQyofDHEWOOOwaXz3PdvgQErvkE+qGBcHJX/Bh8bsO8yoGZC+JBVU
        BsLfJAG5tenq1uCMtxx37f2zg1zYt+Dpk0dcRt1t6qRYqvN2WK7OANwebfs0WAonG5XV7UjKA4NcH
        aqDmLPCQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niV1f-005rqZ-SE; Sun, 24 Apr 2022 05:43:15 +0000
Date:   Sat, 23 Apr 2022 22:43:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: don't trample the gid set in the protofile
Message-ID: <YmTjc6MAO8MTxitd@infradead.org>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
 <164996216024.226891.9018863209797667675.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164996216024.226891.9018863209797667675.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Maybe it's time to finally kill the protofile feature?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
