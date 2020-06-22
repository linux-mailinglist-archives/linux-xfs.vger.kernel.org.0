Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BFC203C57
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jun 2020 18:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgFVQSb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Jun 2020 12:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729211AbgFVQSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 12:18:31 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E398C061573
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 09:18:31 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id h190so1458897vkh.6
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 09:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=qa9uWXPnWGO/xrtJD2ZPjePByt3LKBxys7/Juo/xeSl8UBQ/3yiz006zIFTQ2Iton3
         I4HevJJc1Be2NPQMEH0BvUmDa7aobIAvgvVydzToALbUT642RKcXmMkWvs92iUxN3nD9
         gBT79zzluarn8DeeQ2znamExVLDpKU2H/IlCJi9sgsPisU3VM3iR4hIn5lrws0gZgvQ0
         KChfDnIlVk/mSoYferDXfJz2hLn6JmINarCZemMAxjNBzN14tP8lbdMgW99uLjPWjQ/Y
         k3eHCJMk+p0z+gPDIR/MlS8OmPGeQ2xcQqnHsNYxk+LO2wMslfsj4a/nS8lAWfZlkihc
         kmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=TttEYCisQSMPXAozW2ENbwHrJYC3yjLhlBwuBB/xTwSepgXGxjZ7VQKXUyR1N5oezC
         BQNr90ZntBCYVXADnxoY2RbN+izEh116wHDZFyfaaqkziW7QSi5Gm5Qp3iGzHWaJSWIx
         ZhW2J/cV4X8fhKhylgXVqq3OFma0G17E6ej5AGn6zohFM9wH71/RL2e7yfUxZ96JlDLs
         hu5yxNQtB4VxNWvcvk0DD/PErfjGeYnDdRT4Go/emoaTd+1UtFHtNQr9rKtXFrr4Hatt
         bVq3S+B5cFinfwUtfN3Vyda8erZdWZUJVISD9UkrpxbH3XnWfLH86k6NFsP9T7DwSMT6
         mhVg==
X-Gm-Message-State: AOAM5313akvYRch7NebEYq7PIn5wyR6fHftlLTtxuLnj2O9NLIWr35tf
        MQm1flFt3mYyxcqtyAkz0jAPZn03f5DgvPWTTwX80SoV
X-Google-Smtp-Source: ABdhPJwTcIYSZX/eX0aKO29hAX5mima0KqkBOdB5vGHOOPvxCrOQ5yLPqHfPrpC7vMmfTXT1W9h4XfixsuBbMUaNwCo=
X-Received: by 2002:a1f:bf07:: with SMTP id p7mr16953513vkf.2.1592842709996;
 Mon, 22 Jun 2020 09:18:29 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Grondin <marcfgrondin@gmail.com>
Date:   Mon, 22 Jun 2020 13:18:04 -0300
Message-ID: <CAGkKJSEemoGomhV0f_+-WeU+_UkwhB6LmMkmmU5A4tk+1QHcMg@mail.gmail.com>
Subject: 
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

unsubscribe
