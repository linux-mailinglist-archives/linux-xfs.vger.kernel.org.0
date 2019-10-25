Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB9DE5279
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 19:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505946AbfJYRke (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Oct 2019 13:40:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39396 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731004AbfJYRkd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 13:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0hTCl6i/9Rk9k2UXn+kDzOHKV/6K9R53sFvVFosVbrM=; b=Dp7KJUIIQc+K7OZGuNiq1cJMY
        jnIyrwn+zdtwWXZJ3A3UT9Lo1+upWnh0HpqhZmqRlIktz7FJCaBLMBx8JOWxT5mO5o88pgrUwuesJ
        X5wYjRWhTuTyiAgBMsipyjtis6a+W+/C5HrrZ26d13NosoLYRLCMYoAk4RcU7K0ZvzpvkapnZqZI2
        X0Vx04xgsXg/CGft3WWP1ytFk35orj8xrpZKVcOwjis2gNPmGWLAqkhQinlpaRJRBodnF+iUsYw5m
        Us/yVREtX6jSob1lXUkM7f8Jj8cEKzASg9S5V3mTeitlWaOk6LeiEHW71tR0SPtw8EI1ZywLKesUP
        iuwieitaQ==;
Received: from [88.128.80.25] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO3Zg-0005RL-Lh; Fri, 25 Oct 2019 17:40:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: decruft misc mount related code
Date:   Fri, 25 Oct 2019 19:40:19 +0200
Message-Id: <20191025174026.31878-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series decrufts various bits of vaguely mount / mount option
related code.  The background is the mount API from series, which
currently is a lot more ugly than it should be do the way how
we parse two mount options with arguments into local variables
instead of directly into the mount structure.  This series cleans
that and a few nearby warts.
