Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD24E58FC3C
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Aug 2022 14:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbiHKMar (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Aug 2022 08:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbiHKMaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 08:30:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F524B05;
        Thu, 11 Aug 2022 05:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ahss/HdoMTK7IqfMJGCt1/UfT7
        vm8Mo3Nctj4I6JmQTQNtkM3zlJKwy2fyjA0mvrxk5EdEJAKIHhlAYoGyEDOsI+uFACj6af3dTiMBA
        KgCjp/iNMTGMBZeJxEpinYNbZ2HceJA7URfcRZw1S5VMtJ1oaTg13a33qJiZC3STysaxBVchjr9vG
        zELLbVFF46cxt70BriFiICP9oRHsgXNnahJjSnZDY8oEvV46P1XiRO12N2R81xdJ99pwPflVK1s6K
        xi86953h/GjBGgQWyF6Li5G9Q5cAwqRdQWZs03dUyhfdFr+iXpnwQKvn8xVvpeLcSQRpmzHTp2zTf
        G1wWfLoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oM7Ka-00C8JH-Ge; Thu, 11 Aug 2022 12:30:32 +0000
Date:   Thu, 11 Aug 2022 05:30:32 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] xfs/{015,042,076}: fix mkfs failures with nrext64=1
Message-ID: <YvT2aMUtgXWOPpAS@infradead.org>
References: <166007883231.3274939.3963254355857450803.stgit@magnolia>
 <166007883796.3274939.8920861122422263977.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166007883796.3274939.8920861122422263977.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
