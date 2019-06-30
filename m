Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721BD5AFBB
	for <lists+linux-xfs@lfdr.de>; Sun, 30 Jun 2019 13:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfF3LhA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 30 Jun 2019 07:37:00 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:54982 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF3Lg7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 07:36:59 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Jun 2019 07:36:59 EDT
Received: from tux.wizards.de (pD9EBFA35.dip0.t-ipconnect.de [217.235.250.53])
        by mail02.iobjects.de (Postfix) with ESMTPSA id A8D3C4160A8C
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 13:28:09 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 1DBA3F015F1
        for <linux-xfs@vger.kernel.org>; Sun, 30 Jun 2019 13:28:09 +0200 (CEST)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Include 'xfs: speed up large directory modifications' in 5.3?
Organization: Applied Asynchrony, Inc.
Message-ID: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
Date:   Sun, 30 Jun 2019 13:28:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I have been running with Dave's series for faster directory inserts since
forever without any issues, and the last revision [1] still applies cleanly
to current5.2-rc (not sure about xfs-next though).
Any chance this can be included in 5.3? IMHO it would be a shame if this
fell through the cracks again.

Thanks,
Holger

[1] https://patchwork.kernel.org/project/xfs/list/?series=34713
